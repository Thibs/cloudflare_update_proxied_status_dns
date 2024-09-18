#!/bin/bash

# Configuration hash (put your own data)
declare -A config

config["key1"]="TOKEN1 domain1.com www.domain1.com"
config["key2"]="TOKEN1 domain1.com domain1.com"
config["key3"]="TOKEN2 domain2.com www.domain2.com"
config["key4"]="TOKEN2 domain2.com images.domain2.com"

# Main function to update proxied status
function update_dns_record() {
    local api_key="$1"
    local domain="$2"
    local record="$3"
    local state="$4"  # "on" ou "off"

    # Convert "on" into true and "off" into false
    local proxied=$(echo "$state" | grep -q "on" && echo "true" || echo "false")

    # Retrieve zone_id one time per domain (to avoid useless API calls)
    if [[ -z "${zone_ids[$domain]}" ]]; then
        zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones" -H "Authorization: Bearer $api_key" -H "Content-Type: application/json" | jq -r '.result[] | select(.name == "'"$domain"'") | .id')
        zone_ids[$domain]=$zone_id
    fi

    # Retrieve corresponding dns_record_id 
    if [[ "$record" == "$domain" ]]; then
        dns_record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${zone_ids[$domain]}/dns_records" -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" | jq -r '.result[] | select(.name == "'"$record"'") | select(.type == "A") | .id')
    else
        dns_record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${zone_ids[$domain]}/dns_records" -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" | jq -r '.result[] | select(.name == "'"$record"'") | .id')
    fi

    # Update proxied status
    curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/${zone_ids[$domain]}/dns_records/$dns_record_id" -H "Authorization: Bearer $api_key" -d "{\"proxied\":$proxied}"
}

# Hash to save zone_id
declare -A zone_ids

# Call setting (on or off)
state="$1"

# Loop on configuration
for key in "${!config[@]}"; do
    # Split configuration values
    IFS=" " read -r api_key domain record <<< "${config[$key]}"

    update_dns_record "$api_key" "$domain" "$record" "$state"
done