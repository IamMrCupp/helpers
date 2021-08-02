#!/bin/sh
#
# deleted_comments.sh
# Aaron Cupp @ Study.com LLC  [aaron.cupp (at) study.com]
#
# version: 1.0.0
# updated: 2016.01.07
#
# purpose:  * filter out "Deleted Comment" emails from Contractor Confluence on the postfix relayhost
#
#!/bin/sh
INSPECT_DIR=/var/spool/filter
SENDMAIL=/usr/sbin/sendmail

# Exit codes from <sysexits.h>
EX_TEMPFAIL=75
EX_UNAVAILABLE=69

# Clean up when done or when aborting.
trap "rm -f in.$$" 0 1 2 3 15

# Start processing.
cd $INSPECT_DIR || { echo $INSPECT_DIR does not exist; exit $EX_TEMPFAIL; }

cat >in.$$ || { echo Cannot save mail to file; exit $EX_TEMPFAIL; }

## Do Stuff Here!!
if grep -q "conf2.ue1.prod.study.com" in.$$
then
    if grep -q "<strong>deleted</strong> a comment" in.$$
    then
	logger "(deleted_message postfix filter) Match Found! -- Deleting Email from relayhost"
	rm -f in.$$
    else
	logger "(deleted_message postfix filter) Injecting email back to postfix"
	$SENDMAIL "$@" <in.$$
    fi
else
    logger "(deleted_message postfix filter) Injecting email back to postfix"
    $SENDMAIL "$@" <in.$$
fi
# Stop doing stuff here!!

exit $?
