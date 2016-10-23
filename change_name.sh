#!/usr/bin/env bash
#
#  replace_txt.sh
#
#  Replace Word in File
#    -  search a file for a word and replace with another one
#    ie.  Replace all occurances of Andrew with Christopher in the file todo.txt
#
#  author:  Aaron Cupp <mrcupp@mrcupp.com>
#
# Note:  this can be performed on the command line with 1 line
#   sed -ie s/Andrew/Christopher/g todo.txt
#
#########################################################################################
# Functions and variables here
#########################################################################################

print_help() {
  echo "Usage: replace_txt.sh [OPTION] SEARCH_WORD REPLACE_WORD FILENAME"
  echo "----------------------------------------------------------------"
  echo "SEARCH WORD          The word you want to replace"
  echo "REPLACE_WORD         The word to be used in the replace task"
  echo "FILENAME             Full path to the file to search for replacement"
}

replace_name() {
  echo "Replacing ${count} instanaces of $1 with $2 in $3."
  sed -i .bak -e "s/$1/$2/g" $3  2>&1 
  echo "Done!"
}

check_filename() {
  if [ -e $3 ]; then
    check_file_for_word $1 $2 $3
  else
    print_help
    exit 1
  fi
}

check_file_for_word() {
  count=`grep -oi $1 $3 | wc -l`
  if [ $count -eq 0 ]; then
    echo "Nothing to replace!  Word was not found in file!"
    exit 0
  else
    replace_name $1 $2 $3 $count
  fi
}

#########################################################################################
#  The work happens here
#########################################################################################

if [ $# -ne 3 ]; then
  echo "ERROR!!   Illegal number of parameters!"
  echo ""
  print_help
  exit 1
else
  check_filename $1 $2 $3
fi

exit 0

