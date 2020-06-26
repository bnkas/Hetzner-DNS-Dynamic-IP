# Hetzner DNS Dynamic IP
Script to update Hetzner DNS records with dynamic IP as the IP address changes

## Description
Hetzner has an amazing DNS service where you can host DNS zones for your domains. That way, you can use Hetzner DNS as your Nameservers as opposed to the DNS service offered by your domain registrar: https://dns.hetzner.com/

Hetzner DNS service is completely free, fast, and reliable. Unlike some registrar's DNS service, you are in complete control of the zone files. There are no limits to the number of querries your domains recieve either. 

## DNS Record With Dynamic IP
When you are hosting a server or service (maybe at home) where you are provided with a dynamic IP address by your ISP, if your IP address is changed suddenly, you must also change the DNS record using this IP address; otherwise, you will lose access to the server/service. 

To manage the dynamic IP, we can run an ultra light script every minute or two to check to see if the IP address has changed. If there was a change, we can then immediately make an API call to Hetzner DNS service and update the DNS record with the new IP.

## Install and Usage Steps

- Find script file in this repo called dynip.sh
- On your server, run the following commands:
- `sudo mkdir /usr/local/share/hetzner`
- `sudo nano /usr/local/share/hetzner/dynip.sh`
- Paste script content and save
- Alternatively to pasting: you can use `sudo wget https://raw.githubusercontent.com/bnkas/Hetzner-DNS-Dynamic-IP/master/dynip.sh` to fetch the script directly into /usr/local/share/hetzner directory.
- `sudo chmod +x /usr/local/share/hetzner/dynip.sh`
- `sudo nano /usr/local/share/hetzner/dynip.sh` to open script and edit

Note: the script will create log file and current IP address file in the same directory

- From Hetzner DNS service, obtain **API access key/token** and **Zone ID** (which can be found in URL when you access a zone file via browser)
- You need to also obtain **record ID**, which can be obtained by using API access token and zone ID and running this curl command from hetzner API documentation: https://dns.hetzner.com/api-docs/#operation/GetRecords. So in your terminal, you will need to run a command like this:

```
curl "https://dns.hetzner.com/api/v1/records?zone_id=XYZ" \
     -H 'Auth-API-Token: XYZ'
```     
- In this script, look for XYZ. Any value that equals XYZ must be changed by you in order for the script to work properly. 
- After modifying and saving the script, you can schedule these cron jobs:
  - first cron job will run the script every two minutes 
  - second cron job will reset the log file at midnight, every night. 

- `sudo crontab -e`
- Add the following two lines and save
- `*/2 * * * * /bin/bash /usr/local/share/hetzner/proxy.sh>/dev/null 2>&1`
- `0 0 * * * rm /usr/local/share/hetzner/update-ipadd.log>/dev/null 2>&1`
- Watch log file and Hetzner DNS portal to see the IP address change.



