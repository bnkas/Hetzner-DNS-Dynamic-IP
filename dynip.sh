#!/bin/bash

## Install Steps ##

# Run: sudo mkdir /usr/local/share/hetzner
# Run: sudo nano /usr/local/share/hetzner/dynip.sh
# Run: sudo chmod +x usr/local/share/hetzner/dynip.sh

# The script will create log file and current IP address file in the same directory

# From Hetzner DNS service, obtain API access key/token and Zone ID (which can be found in URL when you access a zone file via browser

# You need to also obtain record ID, which can be obtained by using API access token and zone ID by running this curl command from
# hetzner API documentation: https://dns.hetzner.com/api-docs/#operation/GetRecords

# In the script, look for XYZ. Any value that equal XYZ much be changed by you in order for the script to work for you. 

# After modifying and saving the script, you can schedule these cron jobs:
# first cron job will run the script every two minutes 
# second cron job will reset the log file at midnight, every night. 

# */2 * * * * /bin/bash /usr/local/share/hetzner/proxy.sh>/dev/null 2>&1
# 0 0 * * * rm /usr/local/share/hetzner/update-ipadd.log>/dev/null 2>&1

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
TIME=`date +"%Y-%m-%d %T"`

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Write to files
LOGFILE="/usr/local/share/hetzner/update-ipadd.log"
IPFILE="/usr/local/share/hetzner/update-ipadd.ip"

if ! valid_ip $IP; then
    echo "$TIME - Invalid IP address: $IP" >> "$LOGFILE"
    exit 1
fi

# Check if the IP has changed
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi

if grep -Fxq "$IP" "$IPFILE"; then
    # code if found
    echo "$TIME - IP is still $IP. Exiting" >> "$LOGFILE"
    exit 0
else
    echo "$TIME - IP has changed to $IP" >> "$LOGFILE"
## Update Record
# Updates a record.
curl -X "PUT" "https://dns.hetzner.com/api/v1/records/XYZ" \
     -H 'Content-Type: application/json' \
     -H 'Auth-API-Token: XYZ' \
     -d "{
  \"value\": \"$IP\",
  \"ttl\": XYZ,
  \"type\": \"XYZ\",
  \"name\": \"XYZ\",
  \"zone_id\": \"XYZ\"
}"

fi

# All Done - cache the IP address for next time
echo "$IP" > "$IPFILE"


