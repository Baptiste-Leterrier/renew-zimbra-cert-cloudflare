echo "######### Renew of Zimbra Cert, buckle UP #########"
echo "######### Stopping Zimbra services #########"
sudo -u zimbra /opt/zimbra/bin/zmproxyctl stop
sudo -u zimbra /opt/zimbra/bin/zmmailboxdctl stop
echo "######### Renewing cert against DNS #########"
certbot renew --dns-cloudflare-credentials /root/cert-cloudflare
cd /opt/zimbra/ssl/letsencrypt/
echo "######### Copying cert files #########"
cp /etc/letsencrypt/live/{YOURDOMAINHERE}/* /opt/zimbra/ssl/letsencrypt/
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*
echo "######### Adding X3 cert #########"
cat /root/x3-cert >> /opt/zimbra/ssl/letsencrypt/chain.pem
echo "######### Cerifying certs #########"
sudo -u zimbra /opt/zimbra/bin/zmcertmgr verifycrt comm /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem
echo "######### Backing up config #########"
cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")
echo "######### Copying privkey #########"
sudo -u zimbra cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
echo "######### Deploying cert #########"
sudo -u zimbra /opt/zimbra/bin/zmcertmgr deploycrt comm /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem
echo "######### Restarting Zimbra services #########"
sudo -u zimbra /opt/zimbra/bin/zmcontrol restart
echo "######### All done. #########"
