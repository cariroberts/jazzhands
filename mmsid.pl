#!/usr/bin/perl 

$fileinput = shift(@ARGV);

$apikey = "yourkeyhere";

#no argument defined, no run script
if (length($fileinput) == 0) {
   die "** Usage: scriptname.pl filename\n";
}

#for Perl purposes, we need to call a XML parsing package, so...
use XML::LibXML;

#now for some file operations
#specify the file to open, that value coming from the script runner, as well as an output filename. Also, let's kill the script gracefully if it can't create a file
open(INFILE,$fileinput);
$counter = 1;

open(OUTFILE,">modified_$fileinput") || die "cannot create output file\n";
#assigning reject filename to variable for future function
$rejectFileName = "./rejects_$fileinput";
open(OUTFILE2,">$rejectFileName") || die "cannot create output file\n";
binmode OUTFILE, ":utf8";

#for tidy file purposes, we're going to dump a lot of work files into a temp folder, so let's see if the folder already exists and then create it if not there
if (-e './itemXML') {
  #system("rm ./itemXML/*");
} else {
  system("mkdir ./itemXML");
}


#Onto the crux of our script...do something while the incoming text file isn't empty.  
#Within the following while loop, the script essentially reads an input line, performs the operations within the loop, and then repeats until all input lines are processed
while(<INFILE>) {

    #when in doubt, use the following command to strip pesky line break characters that usually exist in text files
    chomp;

    #we're assuming a consistent file structure in the following variable assignment line, namely a number of fields separated by tab characters
    #you might have to jiggle this with other input files in case they have more/less fields, comma separated values, only a single value, etc
    #our current incoming lines look like this, separated by tabs: mmsid  oclc  Title  Author  Call_Number Library   Location  Barcode
    #so, the following command uses split to assign these values to the specified variable names
    ($mmsID,$oclcnum,$title,$author,$callnum,$library,$location,$barcode) = split /\t/;
    $holdingsListLoc = "./itemXML/holdinglist_$mmsID.xml";
    if (-e $holdingsListLoc) {
       #something
    } else {
      system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings?apikey=$apikey' > $holdingsListLoc"); 
    }
    #we’re going to grab each url for a specific holdings and plug it into the next line
    my $parser = XML::LibXML->new();
     
    my $holdinglistdoc = $parser->parse_file($holdingsListLoc);
    foreach my $holdingLab ($holdinglistdoc->findnodes('/holdings/holding')) {
       $holdingID = $holdingLab->findnodes('./holding_id')->to_literal();
       $itemListLoc = "./itemXML/iteminfo_$mmsID\_$holdingID.xml";

   #when we use an Alma API call that can potentially have many pages of results, we run the curl command once to get the first set of results...and determine how many results are possible
    system("curl --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items?limit=100&offset=0&apikey=$apikey' > itemlist_$holdingID.0.xml");
    $fileCounter = 0;
    my $itemparser = XML::LibXML->new();
    my $itemlist = $itemparser->parse_file("./itemlist_$holdingID.0.xml");
    foreach my $item ($itemlist->findnodes("/items")) {
      my $itemcount = $item->findvalue('@total_record_count');
      if ($itemcount > 100) {
        for ($i=100;$i<$itemcount;$i = $i+100) {
          $fileCounter++;
          system("curl --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items?limit=100&offset=$i&apikey=$apikey' > itemlist_$holdingID.$fileCounter.xml");
        }
      }
    }
    $fileCounter++;
    for ($i=0;$i<$fileCounter;$i++) {
      my $itemparser = XML::LibXML->new();
      my $itemlist = $itemparser->parse_file("./itemlist_$holdingID.$i.xml");
    #  foreach my $itemListing ($itemlist->findnodes('/items/item/item_data')) {


    #if (-e $itemListLoc) {
      #something
    #} else {
     #  system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings/$holdingID/items?limit=100&apikey=$apikey' > $itemListLoc");  
    #} 

    #assign the incoming file to a parser-related variable
   # my $itemdoc = $parser->parse_file($itemListLoc);
    #probably important to note at this point you need to know the general XML structure so you know what/where to get desired data in the next few commands
    #let us create a for/each loop for item sections in the XML, and then a sub loop for each interesting section
    #in the sub-loops, we'll fetch values in which we are interested
    #should only be one of each item, holdingdata, and itemdata section, but this is useful logic when you have a doc with many items and repeating subsections
    foreach my $itemrecord ($itemlist->findnodes('/items/item')) {
        $title="";
	$author="";
	$copyID="";
	$callnum="";
	$pid="";
	$barcode="";
	$description="";
	$library="";
	$location="";
	
        #we need a block for the bibdata
        foreach my $bibDataSec ($itemrecord->findnodes('./bib_data')) {
          $title = $bibDataSec->findnodes('./title')->to_literal();
	  $author = $bibDataSec->findnodes('./author')->to_literal();
        }

        #we need copy_ID, holding_ID from holding_data section
        foreach my $holdingDataSec ($itemrecord->findnodes('./holding_data')) {
          $copyID = $holdingDataSec->findnodes('./copy_id')->to_literal();
          $holdingID = $holdingDataSec->findnodes('./holding_id')->to_literal();
	  $callnum = $holdingDataSec->findnodes('./call_number')->to_literal();
        }
        #for copyID, we really only care if it's greater than one, so we're going to add it to the callnum variable if greater than one
        if ($copyID ne "1" and $copyID ne "") {
          $callnum = $callnum . " copy $copyID";
        }
        #we need pid, description, physical_material_type from item_data section
        foreach my $itemDataSec ($itemrecord->findnodes('./item_data')) {
          $pid = $itemDataSec->findnodes('./pid')->to_literal();
	  $barcode = $itemDataSec->findnodes('./barcode')->to_literal();
          $description = $itemDataSec->findnodes('./description')->to_literal();
          $physMatType = $itemDataSec->findnodes('./physical_material_type')->to_literal();
          $library = $itemDataSec->findnodes('./library')->to_literal();
	  $location = $itemDataSec->findnodes('./location')->to_literal();
        }
        if (($library eq "BIZZELL") && ($location eq "STACKS")) {
	  if (length($barcode)>0) {

            print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$library\t$location\t$barcode\t$physMatType\n";
          } else {
            print OUTFILE2 "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$library\t$location\t$barcode\t$physMatType\n";	
          }
        }      
      }  
    }

  }
}

#close the input/output files
close(INFILE);
close(OUTFILE);
close(OUTFILE2);
if (-z $rejectFileName) {
  system("rm $rejectFileName");
}
