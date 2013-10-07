#!/bin/sh

# reexeecstartscript.sh
# 
# Created by Ben Ferrentino on 9/17/13 for us in NASCAR productions
# Thanks to google, JAMF and stack overflow for getting most of these equations hacked together

# variables
logdir="/var/log/execserver"
log1="${logdir}/startscript.log"

# function list
currentDate=`date`
consoleUser=`/usr/bin/w | grep console | awk '{print $1}'`
testscript=`/etc/test.sh`
#execServerStart=`java -jar /Users/encode/reachserver/exec-server-1.1.2.jar`

# create logs
mkdir ${logdir}
touch ${log1}

# test if the console has a currently logged in user, if not, log in encode and run the startup jar
if test "$consoleUser"  == ""; then
    echo "$currentDate - No user logged in, starting avconvert" >> ${log1}
    $testscript
    echo "$currentDate - script started, see reachexec log for details" >> ${log1}
else
echo "$currentDate - $consoleUser is logged in, exiting" >> ${log1}
fi

exit
