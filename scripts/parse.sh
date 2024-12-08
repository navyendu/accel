#!/bin/bash

TEMP=$1;  #  define a variable TEMP to accept the second parameter,
	  #  ie name of file from command line

CONT=$TEMP;  #the format description file copied to a new file CONT

#  remove everything except alphanumeric value from CONT and save to a file
#  named CROPPED
sed 's/[^a-zA-Z0-9]/ /g' $CONT>CROPPED;


#  identify number of nodes and add it to netlist file
grep node CROPPED|echo "`wc -w` - 1" |bc>NO_OF_NODES;
awk '{printf "~ %s\n",$1;}' NO_OF_NODES>NET_LIST;


##  identify total number of components and total types of components

grep -A 100 main CROPPED>MAIN; # extract main module from the format

#  eliminate all lines other than component description and save to file CORE_DESC
grep -v  probe MAIN|grep -v main|grep -v node|sed -n '/^[^a-zA-Z0-9]\+$/d;p'>CORE_DESC ;

#  get the name of components and save to file NAME_OF_COMP
awk '{print $1;}' CORE_DESC > NAME_OF_COMP;

#  to find the number of types of components,eliminate duplicate entries
#  from the file NAME_OF_COMP and save in file NO_OF_TYPES
sort -u NAME_OF_COMP|wc -l>NO_OF_TYPES;
#  append @ character and add to NET_LIST
awk '{printf "@ %s\n",$1;}' NO_OF_TYPES>>NET_LIST;

#  to find the number of components find the total entries in NAME_OF_COMP
#  append a & sign and ad to NET_LIST
wc -l NAME_OF_COMP|awk '{printf "& %s\n",$1;}' >>NET_LIST;
cat NET_LIST;

