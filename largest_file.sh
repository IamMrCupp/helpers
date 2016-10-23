#!/usr/bin/env bash
#
#  largest_file.sh
#
# Disk Space Hog
#    -  find the largest file on the root filesystems
#
# Author:  Aaron Cupp <mrcupp@mrcupp.com>
#
# Note:   this can be done with a 1-line mess on the cli
#  find / -printf '%s %p\n' 2>&1 | grep -v 'No such file of directory' | sort -nr | head -1
#
#########################################################################################
#  Functions Here
#########################################################################################

find_space_hog() {
  find / -printf '%s %p\n' 2>&1 | grep -v 'No such file of directory' | sort -nr | head -1
}

output_help(){
  echo "Usage: largest_file.sh [-h]"
  echo "-------------------------"
  echo "Default is to output the PID of the offending process."
  echo ""
  echo "-h        Display this help file"
}

#########################################################################################
# The actual work happens below here
#########################################################################################

# do the work here
if [ -z $1 ]; then
  find_space_hog
else
  case $1 in
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
