Last login: Tue Apr 25 15:57:29 on console
d-ip-10-196-225-205:~ cariroberts$ cd Downloads
d-ip-10-196-225-205:Downloads cariroberts$ ls
Biz Serials A-BS	Import 1		list.xlsx		requests		~$Engineering.xlsx
Engineering		jazzhands-master 2	more serials		results.xlsx
d-ip-10-196-225-205:Downloads cariroberts$ cd experimental
d-ip-10-196-225-205:experimental cariroberts$ ls
barcode.pl	mmsid.pl	tasks.pl
d-ip-10-196-225-205:experimental cariroberts$ vi copy.txt
d-ip-10-196-225-205:experimental cariroberts$ chmod 744 barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ perl -p -i -e "s/\r/\n/g" copy.txt 
d-ip-10-196-225-205:experimental cariroberts$ more copy.txt 
A10130282970
ALMA10052404
ALMA10056759
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
100  2478  100  2478    0     0   1727      0  0:00:01  0:00:01 --:--:--  1727
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   5039      0 --:--:-- --:--:-- --:--:--  5039
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   5549      0 --:--:-- --:--:-- --:--:--  5549
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
syntax error at ./barcode.pl line 74, near ") &&"
syntax error at ./barcode.pl line 97, near "}"
Execution of ./barcode.pl aborted due to compilation errors.
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
syntax error at ./barcode.pl line 74, near ") ||"
syntax error at ./barcode.pl line 97, near "}"
Execution of ./barcode.pl aborted due to compilation errors.
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
syntax error at ./barcode.pl line 74, near "$copyID ("
syntax error at ./barcode.pl line 97, near "}"
Execution of ./barcode.pl aborted due to compilation errors.
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
syntax error at ./barcode.pl line 74, near ") or"
syntax error at ./barcode.pl line 97, near "}"
Execution of ./barcode.pl aborted due to compilation errors.
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
syntax error at ./barcode.pl line 74, near "or ne"
syntax error at ./barcode.pl line 97, near "}"
Execution of ./barcode.pl aborted due to compilation errors.
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2478  100  2478    0     0   2180      0  0:00:01  0:00:01 --:--:--  2180
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   5683      0 --:--:-- --:--:-- --:--:--  5683
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   5277      0 --:--:-- --:--:-- --:--:--  5277
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ ./barcode.pl copy.txt 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2478  100  2478    0     0   3461      0 --:--:-- --:--:-- --:--:--  3461
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   1838      0  0:00:01  0:00:01 --:--:-- 2115k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  2521  100  2521    0     0   4451      0 --:--:-- --:--:-- --:--:--  4451
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 
d-ip-10-196-225-205:experimental cariroberts$ vi mmsid.pl 
d-ip-10-196-225-205:experimental cariroberts$ cd ..
d-ip-10-196-225-205:Downloads cariroberts$ ls
Biz Serials A-BS	Import 1		list.xlsx		requests		~$Engineering.xlsx
Engineering		experimental		more serials		results.xlsx
d-ip-10-196-225-205:Downloads cariroberts$ cd more\ serials/
d-ip-10-196-225-205:more serials cariroberts$ ls
itemXML					itemlist_22331565380002042.2.xml	itemlist_22342039480002042.0.xml	itemlist_22415966010002042.1.xml	itemlist_22537424930002042.0.xml
iteminfos_raw_22331565380002042.txt	itemlist_22331565380002042.3.xml	itemlist_22355497180002042.0.xml	itemlist_22415966010002042.2.xml	itemlist_22537424980002042.0.xml
iteminfos_raw_22331565390002042.txt	itemlist_22331565380002042.4.xml	itemlist_22355498970002042.0.xml	itemlist_22415966020002042.0.xml	itemlist_22537424990002042.0.xml
iteminfos_raw_22537877710002042.txt	itemlist_22331565390002042.0.xml	itemlist_22355699560002042.0.xml	itemlist_22422650920002042.0.xml	itemlist_22537425290002042.0.xml
itemlist_22327227630002042.0.xml	itemlist_22338764920002042.0.xml	itemlist_22355699560002042.1.xml	itemlist_22422650920002042.1.xml	itemlist_22537523460002042.0.xml
itemlist_22327227630002042.1.xml	itemlist_22338764920002042.1.xml	itemlist_22360853350002042.0.xml	itemlist_22438933720002042.0.xml	itemlist_22537523470002042.0.xml
itemlist_22327227630002042.2.xml	itemlist_22338764930002042.0.xml	itemlist_22360853350002042.1.xml	itemlist_22438933720002042.1.xml	itemlist_22537877710002042.0.xml
itemlist_22327227640002042.0.xml	itemlist_22338872020002042.0.xml	itemlist_22367033360002042.0.xml	itemlist_22438934000002042.0.xml	itemlist_22537878280002042.0.xml
itemlist_22331125740002042.0.xml	itemlist_22338872030002042.0.xml	itemlist_22367033360002042.1.xml	itemlist_22439518150002042.0.xml	itemlist_22538961740002042.0.xml
itemlist_22331125740002042.1.xml	itemlist_22338897500002042.0.xml	itemlist_22367033370002042.0.xml	itemlist_22439518150002042.1.xml	page_mmsid.pl
itemlist_22331125750002042.0.xml	itemlist_22338897500002042.1.xml	itemlist_22387451000002042.0.xml	itemlist_22444018280002042.0.xml	serials_a_bs_again.txt
itemlist_22331484390002042.0.xml	itemlist_22338897500002042.2.xml	itemlist_22401108960002042.0.xml	itemlist_22505351100002042.0.xml	thirdtry.txt
itemlist_22331484390002042.1.xml	itemlist_22339161810002042.0.xml	itemlist_22401108960002042.1.xml	itemlist_22505423660002042.0.xml
itemlist_22331565380002042.0.xml	itemlist_22339161880002042.0.xml	itemlist_22414451480002042.0.xml	itemlist_22522089460002042.0.xml
itemlist_22331565380002042.1.xml	itemlist_22339161920002042.0.xml	itemlist_22415966010002042.0.xml	itemlist_22537424900002042.0.xml
d-ip-10-196-225-205:more serials cariroberts$ vi page_mmsid.pl 
d-ip-10-196-225-205:more serials cariroberts$ cd ..
d-ip-10-196-225-205:Downloads cariroberts$ ls
Biz Serials A-BS	Engineering		Import 1		experimental		list.xlsx		more serials		requests		results.xlsx		~$Engineering.xlsx
d-ip-10-196-225-205:Downloads cariroberts$ cd ex
-bash: cd: ex: No such file or directory
d-ip-10-196-225-205:Downloads cariroberts$ cd experimental/
d-ip-10-196-225-205:experimental cariroberts$ ls
barcode.pl		copy.txt		itemXML			mmsid.pl		modified_copy.txt	tasks.pl
d-ip-10-196-225-205:experimental cariroberts$ vi barcode
d-ip-10-196-225-205:experimental cariroberts$ vi barcode.pl 

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
      if ($copyID ne "1" and $copyID ne "") {
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


