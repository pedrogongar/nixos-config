#!/usr/bin/env bash
tput civis
while true; do
  clear
  fastfetch --logo none --config "$HOME/.config/fastfetch/config.jsonc"
  sleep 30
done
