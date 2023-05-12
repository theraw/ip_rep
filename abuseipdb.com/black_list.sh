#!/bin/bash

API_KEY="xd"
IPSET_NAME="abuseipdb_blacklist"

# Fetch IP addresses from AbuseIPDB API
response=$(curl -s -G "https://api.abuseipdb.com/api/v2/blacklist" \
  -d confidenceMinimum=75 \
  -d limit=9999999 \
  -H "Key: $API_KEY" \
  -H "Accept: application/json")

# Extract IP addresses from the API response
ip_addresses=$(echo "$response" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
total_ips=$(echo "$ip_addresses" | wc -l)
current_ip=0

# Create the IP set if it doesn't exist
ipset create $IPSET_NAME hash:ip -exist

# Add each IP address to the IP set
for ip in $ip_addresses; do
  ipset add $IPSET_NAME $ip -exist
  ((current_ip++))
  progress=$((current_ip * 100 / total_ips))
  echo "Progress: $progress%"
done
