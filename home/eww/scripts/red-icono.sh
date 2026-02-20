#!/usr/bin/env bash
# ~/.config/eww/scripts/red-icono.sh
# Devuelve el icono Nerd Font correcto según el tipo de conexión

if nmcli -t -f active,ssid dev wifi 2>/dev/null | grep -q "^yes:"; then
  # WiFi conectado — icono según señal
  SIGNAL=$(nmcli -t -f active,signal dev wifi 2>/dev/null | grep "^yes:" | cut -d: -f2)
  if   [ "${SIGNAL:-0}" -ge 70 ]; then echo "󰤨"
  elif [ "${SIGNAL:-0}" -ge 40 ]; then echo "󰤥"
  elif [ "${SIGNAL:-0}" -ge 10 ]; then echo "󰤢"
  else echo "󰤟"
  fi
elif nmcli -t -f type,state dev 2>/dev/null | grep -q "ethernet:connected"; then
  echo "󰈀"
else
  echo "󰤭"
fi
