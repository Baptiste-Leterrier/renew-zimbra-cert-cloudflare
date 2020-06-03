# renew-zimbra-cert-cloudflare
Script to renew your zimbra certificate using Certbot's cloudflare DNS authentication.


Using this script that can be put in cron tab you can automate renew of your zimbra certificate using let's encrypt (Certbot) and auto deploy it.


This script is run as root or set in root crontab.

This script stop zimbra, renew the cert using cloudflare dns authentication, verify and copy all the cert file to zimbra and restart zimbra.

**Prerequisites:**

- python3
- python3-pip

1. **Install certbot and cloudflare**

   Backup your `/etc/letsencrypt` if you have one as we are installing certbot from python-pip
   
   Run `apt remove certbot && apt purge certbot` CAUTION it will remove your previous certs thus the backup before
   
    Run `pip3 install certbot` and `pip3 install certbot-dns-cloudflare`

2. **Import script and files from this repo and configure Cloudflare token**
  
   Create a Cloudflare restricted API Token with Zone:Zone:Read and Zone:DNS:Edit rights.
  
   Replace the token in `cert-cloudflare` with your Cloudflare Token that you created
  
   Apply a chmod 600 on `cert-cloudflare` otherwise certbot will return a warning.

   NB: It is recommended that you run the certbot command to issue your certificate now as you have to enter email adress etc. Also you can test if the command works: 

   `certbot certonly --dns-cloudflare --dns-cloudflare-credentials <path>/cert-cloudflare -d yourdomain`

   Don't hesitate to use --dry-run !

3. **Configure the script**
Edit `renew-zim-cert.sh` to change `cp /etc/letsencrypt/live/{YOURDOMAINHERE}/* /opt/zimbra/ssl/letsencrypt/` with you actual domain/folder

4. **Add to crontab**
I used this crontab to renew every two month
`0 0 1 */2 * /root/renew-zim-cert.sh >> /var/log/renew-certif.log 2>&1`


TODO:

- Check if the certificate is OK (with remaining date)
