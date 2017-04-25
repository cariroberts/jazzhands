#!/usr/bin/perl 

#for Perl purposes, we need to call a XML parsing package, so...
use XML::LibXML;

#now for some file operations
#specify the output filename. Also, let's kill the script gracefully if it can't create a file
open(OUTFILE,">outfile") || die "cannot create output file\n";
binmode OUTFILE, ":utf8";

#for tidy file purposes, we're going to dump a lot of work files into a temp folder, so let's see if the folder already exists and then create it if not there
if (-e './itemXML') {
  #system("rm ./itemXML/*");
} else {
  system("mkdir ./itemXML");
}

    #we will be running an API call to retrieve Patron Physical Item requests for Storage
system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/task-lists/requested-resources?library=STORAGE&circ_desk=DEFAULT_CIRC_DESK&limit=10&offset=0&apikey=l7xx61b940d9c211450e99c500b5bfbbaf92' > requeststasklist");
    
#we’re going to grab each url for a specific request and plug it into the next line
my $parser = XML::LibXML->new();
     
my $holdinglistdoc = $parser->parse_file("requeststasklist");
foreach my $resourceLib ($holdinglistdoc->findnodes('/requested_resources/requested_resource')) {
  foreach my $holdingLib ($resourceLib->findnodes('./resource_metadata')) {
   $mmsID = $holdingLib->findnodes('./mms_id')->to_literal();
   $titlerequestinfo = "./itemXML/titlerequestinfo_$mmsID.xml";

#second API call to get the actual items that have been requested

   system("curl -L --request GET 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/requests?request_type=HOLD&status=active&apikey=l7xxa730c5d8d8844676ab5e1607d1161322' > $titlerequestinfo");  
   #assign the incoming file to a parser-related variable
   my $itemdoc = $parser->parse_file($titlerequestinfo);
   #probably important to note at this point you need to know the general XML structure so you know what/where to get desired data in the next few commands
      #let us create a for/each loop for item sections in the XML, and then a sub loop for each interesting section
      #in the sub-loops, we'll fetch values in which we are interested
      #should only be one of each item, holdingdata, and itemdata section, but this is useful logic when you have a doc with many items and repeating subsections
      #we are looking to grab each user request that currently exists relating to this title
   foreach my $itemrecord ($itemdoc->findnodes('/user_requests/user_request')) {
    
     $title = $itemrecord->findnodes('./title')->to_literal();
     $userid = $itemrecord->findnodes('./user_primary_id')->to_literal();
     $requestid = $itemrecord->findnodes('./request_id')->to_literal();
     $description = $itemrecord->findnodes('./description')->to_literal();
     $barcode = $itemrecord->findnodes('./barcode')->to_literal();
     $physMatType = $itemrecord->findnodes('./material_type')->to_literal();
     $comment = $itemrecord->findnodes('./comment')->to_literal();
     $comment =~ s/\n//g;
     $comment =~ s/\r//g;
     $copyID = "";
     $holdingid = "";
     $callnum ="";
     $pid = "";
     $library = "";
     $location = "";
     $author = "";
	
     if (length($barcode)>0) {  
       system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/items?item_barcode=$barcode&apikey=l7xxc9bd7984f951474a8974d6ed0ef3d712' > ./itemXML/iteminfo_$barcode.xml");
       #now we have an XML file ready for parsing; we'll specify that filename in a variable and then start up the XML parser
       $xmlFileInput = "./itemXML/iteminfo_$barcode.xml";
       my $parser = XML::LibXML->new();
      #assign the incoming file to a parser-related variable
      my $itemdoc = $parser->parse_file($xmlFileInput);
      #probably important to note at this point you need to know the general XML structure so you know what/where to get desired data in the next few commands
      #let us create a for/each loop for item sections in the XML, and then a sub loop for each interesting section
      #in the sub-loops, we'll fetch values in which we are interested
      #should only be one of each item, holdingdata, and itemdata section, but this is useful logic when you have a doc with many items and repeating subsections
     foreach my $itemrecord ($itemdoc->findnodes('/item')) {
      #we need copy_ID, holding_ID from holding_data section
      foreach my $holdingDataSec ($itemrecord->findnodes('./holding_data')) {
       $callnum = $holdingDataSec->findnodes('./call_number')->to_litral();
       $copyID = $holdingDataSec->findnodes('./copy_id')->to_literal();
       $holdingID = $holdingDataSec->findnodes('./holding_id')->to_literal();
      }
      #for copyID, we really only care if it's greater than one, so we're going to add it to the callnum variable if greater than one
      if ($copyID ne "1") {
	$callnum = $callnum . " copy $copyID";
      }
      #we need pid, description, phyical_material_type from item_data section
      foreach my $itemDataSec ($itemrecord->findnodes('./item_data')) {
        $pid = $itemDataSec->findnodes('./pid')->to_literal();
	$library = $itemDataSec->findnodes('./library')->to_literal();
	$location = $itemDataSec->findnodes('./location')->to_literal();
      }
      #we need bib data too
      foreach my $bibDataSec ($itemrecord->findnodes('./bib_data')) { 
	$author = $bibDataSec->findnodes('./author')->to_literal();
      }
      if ($library eq "STORAGE"){
         print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$barcode\t$physMatType\t$userid\t$requestid\t$comment\n";
      } 
    } 
  } else {
	  print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$barcode\t$physMatType\t$userid\t$requestid\t$comment\n";
  }
      
  }
 }
}

#close the input/output files

close(OUTFILE);
