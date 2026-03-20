#!/bin/bash

WIFI_ENABLED=$(nmcli radio wifi)
WIFI_INFO=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep '^yes' | head -1)
ETH_INFO=$(nmcli -t -f type,state,device con show --active 2>/dev/null | grep '^.*ethernet.*activated' | head -1)

echo "WIFI_ENABLED=$WIFI_ENABLED"
if [ -n "$WIFI_INFO" ]; then
  SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
  SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)
  echo "WIFI_CONNECTED=yes"
  echo "WIFI_SSID=$SSID"
  echo "WIFI_SIGNAL=$SIGNAL"
else
  echo "WIFI_CONNECTED=no"
fi

if [ -n "$ETH_INFO" ]; then
  ETH_DEV=$(echo "$ETH_INFO" | cut -d: -f3)
  echo "ETH_CONNECTED=yes"
  echo "ETH_DEVICE=$ETH_DEV"
else
  echo "ETH_CONNECTED=no"
fi
