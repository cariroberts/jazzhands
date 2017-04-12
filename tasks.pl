#!/usr/bin/perl 

$fileinput = shift(@ARGV);

#no argument defined, no run script
if (length($fileinput) == 0) {
        die "** Usage: scriptname.pl filename\n";
   }

#for Perl purposes, we need to call a XML parsing package, so...
use XML::LibXML;

#now for some file operations
#specify the file to open, that value coming from the script runner, as well as an output filename. Also, let's kill the script gracefully if it can't create a file
open(INFILE,$fileinput);
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

    #we will be running an API call to retrieve Patron Physical Item requests for Storage
    #our current incoming lines look like this, separated by tabs:  Library  Circ Desk
    #so, the following command uses split to assign these values to the specified variable names
    #($library,$circ_desk) = split /\t/;
    $taskListLoc = "./itemXML/tasklist_$mmsID.xml";
    if (-e $taskListLoc) {
       #something
    } else {
      system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/task-lists/requested-resources?library=STORAGE&circ_desk=DEFAULT_CIRC_DESK&limit=10&offset=0&apikey=l7xx61b940d9c211450e99c500b5bfbbaf92' > $taskListLoc");
    }
    
    #we’re going to grab each url for a specific request and plug it into the next line
     my $parser = XML::LibXML->new();
     
     my $holdinglistdoc = $parser->parse_file($holdingsListLoc);
     foreach my $holdingLab ($holdinglistdoc->findnodes('/holdings/holding')) {
       $holdingID = $holdingLab->findnodes('./holding_id')->to_literal();
       $itemListLoc = "./itemXML/iteminfo_$mmsID\_$holdingID.xml";
     if (-e $itemListLoc) {
       #something
     } else {
       system("curl -L --request GET 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/requests?request_type=HOLD&status=active&apikey=l7xxa730c5d8d8844676ab5e1607d1161322' > $itemListLoc");  
     } 

      #assign the incoming file to a parser-related variable
      my $itemdoc = $parser->parse_file($itemListLoc);
      #probably important to note at this point you need to know the general XML structure so you know what/where to get desired data in the next few commands
      #let us create a for/each loop for item sections in the XML, and then a sub loop for each interesting section
      #in the sub-loops, we'll fetch values in which we are interested
      #should only be one of each item, holdingdata, and itemdata section, but this is useful logic when you have a doc with many items and repeating subsections
      foreach my $itemrecord ($itemdoc->findnodes('/items/item')) {

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
        if ($copyID ne "1") {
          $callnum = $callnum . " copy $copyID";
        }
        #we need pid, description, physical_material_type from item_data section
        foreach my $itemDataSec ($itemrecord->findnodes('./item_data')) {
          $pid = $itemDataSec->findnodes('./pid')->to_literal();
	  $barcode = $itemDataSec->findnodes('./barcode')->to_literal();
          $description = $itemDataSec->findnodes('./description')->to_literal();
          $physMatType = $itemDataSec->findnodes('./physical_material_type')->to_literal();
	  $comment = $itemDataSec ->findnodes('./comment') ->to_literal();
        }
	  if (length($barcode)>0) {
            print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$barcode\t$physMatType\n";
          } else {
            print OUTFILE2 "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$barcode\t$physMatType\n";	
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
