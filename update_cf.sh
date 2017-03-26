#!/bin/sh
set -e
. /etc/env
api_url="https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records"

# Get current IP address and identifier from Cloudflare
curl -s -X GET "$api_url?type=A&name=$CF_DOMAIN&match=all" \
  -H "X-Auth-Email: $CF_EMAIL" \
  -H "X-Auth-Key: $CF_API_KEY" \
  -H "Content-Type: application/json" > /tmp/domain.json

identifier=`jq -r '.result[0].id' /tmp/domain.json`
current_ip=`jq -r '.result[0].content' /tmp/domain.json`
rm tmp/domain.json
[ $DEBUG ] && echo "Current IP is: $current_ip"

# Get external IP address
wan_ip=`curl -s https://ipinfo.io/ip`
[ $DEBUG ] && echo "WAN IP is: $wan_ip"

# Update DNS record
if [ "$wan_ip" != "$current_ip" ]; then
  curl -sq -X PUT "$api_url/$identifier" \
    -H "X-Auth-Email: $CF_EMAIL" \
    -H "X-Auth-Key: $CF_API_KEY" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$CF_DOMAIN\",\"content\":\"$wan_ip\"}"

  [ $? = 0 ] && echo "Updated IP of \"$CF_DOMAIN\" to \"$ip\""

elif [ $DEBUG ]; then
  echo IP adress is unchanged
fi
