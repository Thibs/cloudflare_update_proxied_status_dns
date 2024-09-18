# cloudflare_update_proxied_status_dns

This bash script use Cloudflare API to update **"Proxy Status"** 

The Proxy Status can be changed to "Proxied" (=using Cloudflare services) or "DNS only" (by-pass Cloudflare services)

The main usage is to temporary disable it to renew local Let's Encrypt certificate (even if Cloudflare could work with an expirate certificate)

## prerequisite

1° Having a Cloudflare account with at least one linked domain

2° Create a API key for this usage

To achieve this :

- on the top right corner of Cloudflare web interface, choose "My Profile"
- on the left colum,, choose "API tokens"
- create a token by choosing "Edit zone DNS" template

Take note of this token because it will nevere be displayed again

3° jq library need to be installed

On Debian/Ubuntu it can be easily install with following command

`apt install jq`

## configuration

Edit the script to add your token / concerned domain/dns record having proxied status to change

e.g. :

```
config["key1"]="TOKEN1 domain1.com www.domain1.com"
config["key2"]="TOKEN1 domain1.com domain1.com"
config["key3"]="TOKEN2 domain2.com www.domain2.com"
config["key4"]="TOKEN2 domain2.com images.domain2.com"
```
