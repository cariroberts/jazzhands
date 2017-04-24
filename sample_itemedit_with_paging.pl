#!/usr/bin/perl 

$fileinput = shift(@ARGV);

if (length($fileinput) == 0) {
   die "** Usage: itemedit.pl filename\n";
}

use XML::LibXML;

open(INFILE,$fileinput);
$counter = 1;
#file input assumed to be mmsID, holdingID, and callnum, separated by tabs
while(<INFILE>) {
    chomp;
    ($mmsID,$holdingID,$callnum) = split /\t/;
    #when we use an Alma API call that can potentially have many pages of results, we run the curl command once to get the first set of results...and determine how many results are possible
    system("curl --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items?limit=100&offset=0&apikey=l7xxe8a9801f483548eea2a11d08ef3833a8' > itemlist_$holdingID.0.xml");
    $fileCounter = 0;
    my $itemparser = XML::LibXML->new();
    my $itemlist = $itemparser->parse_file("./itemlist_$holdingID.0.xml");
    foreach my $item ($itemlist->findnodes("/items")) {
      my $itemcount = $item->findvalue('@total_record_count');
      if ($itemcount > 100) {
        for ($i=100;$i<$itemcount;$i = $i+100) {
          $fileCounter++;
          system("curl --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items?limit=100&offset=$i&apikey=l7xxe8a9801f483548eea2a11d08ef3833a8' > itemlist_$holdingID.$fileCounter.xml");
        } 
      } 
    }
    open(OUTFILE,">iteminfos_raw_$holdingID.txt");
    $fileCounter++; 
    for ($i=0;$i<$fileCounter;$i++) {
      my $itemparser = XML::LibXML->new();
      my $itemlist = $itemparser->parse_file("./itemlist_$holdingID.$i.xml");
      foreach my $itemListing ($itemlist->findnodes('/items/item/item_data')) {
         #get item PID
         foreach my $pidField ($itemListing->findnodes('./pid')) {
           $itemPID = $pidField->to_literal;
         }
         system("curl --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items/$itemPID?view=brief&apikey=l7xxe8a9801f483548eea2a11d08ef3833a8' > incitem_$itemPID.xml");
         system("cp incitem_$itemPID.xml ./Backup/");
         $fileinput = "./incitem_$itemPID.xml";
         $altCallNum = "";
         $description = "";
         my $parser = XML::LibXML->new();
         my $itemdoc = $parser->parse_file($fileinput);
         foreach my $itemrecord ($itemdoc->findnodes('/')) {
           foreach my $altCallNoField ($itemrecord->findnodes('./item/item_data/alternative_call_number')) {
             $altCallNum = $altCallNoField->to_literal;
             if ($altCallNum =~ /^$callnum/) {
               $newDescription = $altCallNum;
               $newDescription =~ s/$callnum//g;
               $newDescription =~ s/^\s+//;
             } else {
               print OUTFILE "no callno string replaced ";
               $newDescription = "";
             }
           }
           foreach my $descNote ($itemrecord->findnodes('./item/item_data/description')) {
             $description = $descNote->to_literal;
             if (length($newDescription) == 0) {
               print OUTFILE "No new description to insert\n";
             } elsif (length($description) > 0) {
               print OUTFILE "Description already exists\n";
             } else {
               $description = $newDescription;
               $descNote->appendText($description);
             }
             #my $text = XML::LibXML::Text->new("$descNote");
             #$descNote->appendText($text);
           }
         }
         print OUTFILE "$mmsID\t$holdingID\t$itemPID\t$callnum\t$altCallNum\t$description\n"; 
         open ($output,">$fileinput") or die "could not create $fileinput\n";
         print $output $itemdoc->toString;
         close ($output);

         system("curl -X PUT -d \@$fileinput 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items/$itemPID?apikey=l7xxe8a9801f483548eea2a11d08ef3833a8' -H \"Content-Type: application/xml\" --include >> feedback_from_post");
         system("mv incitem_$itemPID.xml ./Processed/");
      }
    }
    close(OUTFILE);
}

close(INFILE);
