# cloudflare_update_proxied_status_dns

This bash script use Cloudflare API to update **"Proxy Status"** 

The Proxy Status can be changed to "Proxied" (=using Cloudflare services) or "DNS only" (bypass Cloudflare services)

The main usage is to temporary disable Cloudflare services to renew local Let's Encrypt certificates (even if Cloudflare could work with an expirated certificate)

## prerequisite

1° Having a Cloudflare account with at least one linked domain

2° Create a API key for this usage

To achieve this :

- On the top right corner of Cloudflare web interface, choose "My Profile"
- On the left colum,, choose "API tokens"
- Create a token by choosing "Edit zone DNS" template

![image](https://github.com/user-attachments/assets/72c93d27-2059-49af-99e7-42d87964b893)

Take note of this token because it will never be displayed again

3° jq library need to be installed

On Debian/Ubuntu it can be easily install with following command

`apt install jq`

On RedHat/Rocky Linux (*epel repo* needs to be configured)

`yum install jq -y`

## installation

- Download it `wget https://raw.githubusercontent.com/Thibs/cloudflare_update_proxied_status_dns/main/cloudflare_update_proxied_status_dns.sh`
- Make it executable `chmod +x cloudflare_update_proxied_status_dns.sh`

## configuration

Edit the script to add your token / concerned domain / dns record having *proxied status* to be modified

e.g. :

```
config["key1"]="TOKEN1 domain1.com www.domain1.com"
config["key2"]="TOKEN1 domain1.com domain1.com"
config["key3"]="TOKEN2 domain2.com www.domain2.com"
config["key4"]="TOKEN2 domain2.com images.domain2.com"
```

## usage

`./cloudflare_update_proxied_status_dns.sh on|off`

Typical usage is to put it in cron before and after Let's encrypt certificates process renewal

e.g. :

```
15 4 * * * /root/scripts/cloudflare_dns.sh off 2>&1 >>/dev/null
20 4 * * * certbot renew 2>&1 >>/dev/null
30 4 * * * /root/scripts/cloudflare_dns.sh on 2>&1 >>/dev/null
```
