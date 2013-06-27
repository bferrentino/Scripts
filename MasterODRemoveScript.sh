#!/bin/bash

# Heavily modified from code by Patrick Gallagher http://www.macadmincorner.com
# Updated 06/25/13 by Ben Ferrentino and Jared Egenes for NASCAR
# dogs > cats

# Static variables - Enter your information here
# OD Admin
odAdmin=""
# OD Admin PW
odPassword=""
# FQDN of OD domain
domain=""
# Invaild OD address
badDomain1=""
# Invaild OD address
badDomain2=""
# Invaild OD address
badDomain3=""
# Primary OD group
computerGroup=""

# variables
nicAddress=`ifconfig en0 | grep ether | awk '{print $2}'`
computerName=`networksetup -getcomputername`
computerSecureName=$computerName$
check4OD=`dscl localhost -list /LDAPv3`
check4BadODacct=`dscl /LDAPv3/${domain} -read Computers/${computerName} RecordName | awk '{ print $2 }'`
listAllRecords=`dscl /LDAPv3/${domain} -search /Computers ENetAddress ${nicAddress} | awk ' { print $1 } ' | sed -e '/)/d' -e '/:/d'`
falseENet=`dscl /LDAPv3/${domain} -search /Computers ENetAddress ${nicAddress} | awk ' { print $1 } ' | sed -e '/)/d' -e '/:/d' | grep -wv ${computerSecureName} | sed -n 1p`

# FIRST OD check
if [ "${check4OD}" == "${domain}" ]; then
        dsconfigldap -r ${domain}
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain
                sleep 3
        dsconfigldap -r ${domain}
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain -u $odAdmin -p $odPassword
                sleep 3
echo "This machine was rebound to ${domain}."

# SECOND OD check
else if [ "${check4OD}" == "${badDomain1}" ]; then
        dsconfigldap -r "${badDomain1}"
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain
                sleep 3
        dsconfigldap -r ${domain}
                sleep 3         
        echo "y" | dsconfigldap -a $domain -n $domain -u $odAdmin -p $odPassword
                sleep 3
echo "This machine was bound to ${domain}."

# THIRD OD check
else if [ "${check4OD}" == "${badDomain2}" ]; then
        dsconfigldap -r "${badDomain2}"
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain
                sleep 3
        dsconfigldap -r ${domain}
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain -u $odAdmin -p $odPassword
                sleep 3
echo "This machine was bound to ${domain}."

# FOURTH OD check
else if [ "${check4OD}" == "${badDomain3}" ]; then
        dsconfigldap -r "${badDomain3}"
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain
                sleep 3
        dsconfigldap -r ${domain}
                sleep 3
        echo "y" | dsconfigldap -a $domain -n $domain -u $odAdmin -p $odPassword
                sleep 3
echo "This machine was bound to ${domain}."

# Fresh bind to OD
else
        echo "y" | dsconfigldap -a $domain -n $domain -u $odAdmin -p $odPassword
                sleep 3
fi
fi
fi
fi

# Check for matching ENetAddress and non-matching records
if [ "${computerSecureName}" != "${listAllRecords}" ]; then
        echo "Oh snap - Found something off!"
                dscl /LDAPv3/${domain} -delete /Computers/${falseENet}
                sleep 10
        echo "Deleted that sucker"
fi

# Another Check
if [ "${computerSecureName}" != "${listAllRecords}" ]; then
        echo "Crap - we've got another one"
                dscl /LDAPv3/${domain} -delete /Computers/${falseENet}
                sleep 10
        echo "Removed as well"
fi

# Last Check
if [ "${computerSecureName}" = "${listAllRecords}" ]; then
        echo "BAM - We're g2g"
fi

# Add to casperimage_corp
dscl /LDAPv3/${domain} -append ComputerGroups/${computerGroup} GroupMembers ${computerSecureName} -u ${odAdmin} -p ${odPassword}
dscl /LDAPv3/${domain} -append ComputerGroups/${computerGroup} GroupMembership ${computerSecureName} -u ${odAdmin} -p ${odPassword}

echo "Have a Nice Day :)"

exit
