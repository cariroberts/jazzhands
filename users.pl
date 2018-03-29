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
if (-e ‘./usersXML') {
#  system("rm ./usersXML/*");
} else {
  system("mkdir ./usersXML");
}


#Onto the crux of our script...do something while the incoming text file isn't empty.  
#Within the following while loop, the script essentially reads an input line, performs the operations within the loop, and then repeats until all input lines are processed
while(<INFILE>) {

    #when in doubt, use the following command to strip pesky line break characters that usually exist in text files
    chomp;


    ($primary_id) = split /\t/;
 
    #now we have some variable fields populated, particularly the barcode.  Let's go get some other metadata by using an Alma API call.  There are more graceful ways to accomplish this, but I often end up running fetch/parse scripts multiple times to augment results, so I favor a system-level curl call that creates XML files on the local machine, and then comment out the API call in future script runs and just act on the data files it already created
    system("curl -L --request GET 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/users/users?user_id=$user_id&user_id_type=all_unique&view=full&expand=fees&apikey=l7xxc9bd7984f951474a8974d6ed0ef3d712' > ./usersXML/userinfo_$users.xml");



    #now we have an XML file ready for parsing; we'll specify that filename in a variable and then start up the XML parser
    $xmlFileInput = “./usersXML/userinfo_$users.xml";
    if(-s $xmlFileInput) {

    my $parser = XML::LibXML->new();
	$primary_id = "";
        $first_name = "";
        $last_name ="";
        $full_name = "";
        $pin_number = "";
        $user_group_desc ="";
        $status_desc = "";
  

    #assign the incoming file to a parser-related variable
    my $userdoc = $parser->parse_file($xmlFileInput);

    foreach my $users ($userdoc->findnodes('/item')) {

      foreach my $usersDataSec ($userrecord->findnodes('./userinfo_data')) {
      $primary_id = $usersDataSec->findnodes(‘./primary_id’)->to_literal(); 

      }
   
      foreach my $usersDataSec ($userrecord->findnodes(‘./users_data')) {
        $primary_id = $usersDataSec->findnodes(‘./primary_id’)->to_literal();
        $first_name = $usersDataSec->findnodes(‘./first_name’)->to_literal();
        $last_name = $usersDataSec->findnodes(‘./last_name’)->to_literal();
        $full_name = $usersDataSec->findnodes(‘./full_name’)->to_literal();
        $pin_number = $usersDataSec->findnodes(‘./pin_number’)->to_literal();
        $user_group_desc = $usersDataSec->findnodes('./user_group_desc')->to_literal();
        $status_desc = $usersDataSec->findnodes(‘./status_desc’)->to_literal();

      }
   }
    #knowing that our desired output is the bulk of the original string along with the new fields, let us print appropriately 
      if(length($primary_id) >2) {
      print OUTFILE "$primary_id\t$first_name\t$last_name\t$full_name\t$pin_number\t$user_group\t$status_desc\n";
      }	
   }
}

#close the input/output files
close(INFILE);
close(OUTFILE);
