#!/usr/bin/env bash
#
#  fd_hog.sh
#
# File Descriptor Hog
#    -  find the PID with the most open file descriptors
#
# Author:  Aaron Cupp <mrcupp@mrcupp.com>
#
# Note:   This can be done with a 1-line mess on the cli
#  lsof | awk '{ print $2 }' | sort -rn | uniq -c | sort -rn | head -1 | awk '{ print $2 }'
#
#########################################################################################
# Functions make life easier
#########################################################################################

output_pid(){
  lsof | awk '{ print $2 }' | sort -rn | uniq -c | sort -rn | head -1 | awk '{ print $2 }'
}

output_verbose(){
  lsof | awk '{ print $2 " " $1 }' | sort -rn | uniq -c | sort -rn | head -1 | \
    awk '{ print "FD HOG:  " $1 " File Descriptors in use by " $3 "(pid:" $2 ")" }'
}

output_help(){
  echo "Usage: fd_hog.sh [OPTION]"
  echo "-------------------------"
  echo "Default is to output the PID of the offending process."
  echo ""
  echo "-p        (DEFAULT) Output the PID of offending process"
  echo "          * good for embedding in scripts"
  echo ""
  echo "-v        Output with more information about the offending process"
  echo ""
  echo "-h        Display this help file"
}

#########################################################################################
# Make it all work
#########################################################################################

# if no options passed to the script, default to PID output
if [ -z $1 ]; then
  output_pid
else
  # we have options;  switch on the info
  case $1 in
    -p )
      output_pid
      ;;
    -v )
      output_verbose
      ;;
    -h )
      output_help
      ;;
    * )
      output_help
      exit 1
      ;;
  esac
fi

exit 0
