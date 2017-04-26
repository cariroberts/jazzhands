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
      system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/holdings?apikey=l7xxc9bd7984f951474a8974d6ed0ef3d712' > $holdingsListLoc");
    }
    #we’re going to grab each url for a specific holdings and plug it into the next line
    my $parser = XML::LibXML->new();

    my $holdinglistdoc = $parser->parse_file($holdingsListLoc);
    foreach my $holdingLab ($holdinglistdoc->findnodes('/holdings/holding')) {
       $holdingID = $holdingLab->findnodes('./holding_id')->to_literal();
       $itemListLoc = "./itemXML/iteminfo_$mmsID\_$holdingID.xml";

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
    $fileCounter++;
    for ($i=0;$i<$fileCounter;$i++) {
      my $itemparser = XML::LibXML->new();
      my $itemlist = $itemparser->parse_file("./itemlist_$holdingID.$i.xml");
