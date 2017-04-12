#!/usr/bin/perl 

#for Perl purposes, we need to call a XML parsing package, so...
use XML::LibXML;

#now for some file operations
#specify the output filename. Also, let's kill the script gracefully if it can't create a file
open(OUTFILE,">outfile") || die "cannot create output file\n";
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

      system("curl -L --request GET 'https://api-na.hosted.exlibrisgroup.com/almaws/v1/task-lists/requested-resources?library=STORAGE&circ_desk=DEFAULT_CIRC_DESK&limit=10&offset=0&apikey=l7xx61b940d9c211450e99c500b5bfbbaf92' > requeststasklist");
    
    #we’re going to grab each url for a specific request and plug it into the next line
     my $parser = XML::LibXML->new();
     
     my $holdinglistdoc = $parser->parse_file("requesttasklist");
     foreach my $holdingLib ($holdinglistdoc->findnodes('/requested_resource/resource_metadata')) {
       $mmsID = $holdingLib->findnodes('./mms_id')->to_literal();
       $titlerequestinfo = "./itemXML/titlerequestinfo_$mmsID.xml";

#second API call to get the actual items that have been requested

       system("curl -L --request GET 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/bibs/$mmsID/requests?request_type=HOLD&status=active&apikey=l7xxa730c5d8d8844676ab5e1607d1161322' > $titlerequestinfo");  
     } 

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
	
	  if (length($barcode)>0) {
	  
	  
	  
	  }
            print OUTFILE "$mmsID\t$holdingID\t$pid\t$title\t$author\t$callnum\t$description\t$barcode\t$physMatType\n";
  
      }  
      
    }
}

#close the input/output files

close(OUTFILE);
close(OUTFILE2);
if (-z $rejectFileName) {
  system("rm $rejectFileName");
}
