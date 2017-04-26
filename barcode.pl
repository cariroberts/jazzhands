#!/usr/bin/perl 

$fileinput = shift(@ARGV);

#no argument defined, no run script
if (length($fileinput) == 0) {
        die "** Usage: retredit.pl filename\n";
   }

#for Perl purposes, we need to call a XML parsing package, so...
use XML::LibXML;

#now for some file operations
#specify the file to open, that value coming from the script runner, as well as an output filename. Also, let's kill the script gracefully if it can't create a file
open(INFILE,$fileinput);
open(OUTFILE,">modified_$fileinput") || die "cannot create output file\n";
binmode OUTFILE, ":utf8";

#for tidy file purposes, we're going to dump a lot of work files into a temp folder, so let's see if the folder already exists and then create it if not there
if (-e './itemXML') {
#  system("rm ./itemXML/*");
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
    ($barcode) = split /\t/;
 
    #now we have some variable fields populated, particularly the barcode.  Let's go get some other metadata by using an Alma API call.  There are more graceful ways to accomplish this, but I often end up running fetch/parse scripts multiple times to augment results, so I favor a system-level curl call that creates XML files on the local machine, and then comment out the API call in future script runs and just act on the data files it already created
    system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/items?item_barcode=$barcode&apikey=l7xxc9bd7984f951474a8974d6ed0ef3d712' > ./itemXML/iteminfo_$barcode.xml");

    #now we have an XML file ready for parsing; we'll specify that filename in a variable and then start up the XML parser
    $xmlFileInput = "./itemXML/iteminfo_$barcode.xml";
    if(-s $xmlFileInput) {

    my $parser = XML::LibXML->new();
	$copyID = "";
        $holdingID = "";
        $callnum ="";
        $pid = "";
        $description = "";
        $physMatType ="";
        $library = "";
        $location = "";
        $title = "";
        $author = "";
        $mmsID = "";

    #assign the incoming file to a parser-related variable
    my $itemdoc = $parser->parse_file($xmlFileInput);
    #probably important to note at this point you need to know the general XML structure so you know what/where to get desired data in the next few commands
    #let us create a for/each loop for item sections in the XML, and then a sub loop for each interesting section
    #in the sub-loops, we'll fetch values in which we are interested
    #should only be one of each item, holdingdata, and itemdata section, but this is useful logic when you have a doc with many items and repeating subsections
    foreach my $itemrecord ($itemdoc->findnodes('/item')) {

 #we need copy_ID, holding_ID from holding_data section
      foreach my $holdingDataSec ($itemrecord->findnodes('./holding_data')) {
      $callnum = $holdingDataSec->findnodes('./call_number')->to_literal(); 
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
        $description = $itemDataSec->findnodes('./description')->to_literal();
        $physMatType = $itemDataSec->findnodes('./physical_material_type')->to_literal();
	$library = $itemDataSec->findnodes('./library')->to_literal();
	$location = $itemDataSec->findnodes('./location')->to_literal();
      }
      #we need bib data too
      foreach my $bibDataSec ($itemrecord->findnodes('./bib_data')) { 
	$title = $bibDataSec->findnodes('./title')->to_literal();
	$author = $bibDataSec->findnodes('./author')->to_literal();
	$mmsID = $bibDataSec->findnodes('./mms_id')->to_literal();	
      }
   }
    #knowing that our desired output is the bulk of the original string along with the new fields, let us print appropriately 
      if(length($mmsID) >2) {
      print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$library\t$location\t$barcode\t$physMatType\n";
      }	
   }
}

#close the input/output files
close(INFILE);
close(OUTFILE);
