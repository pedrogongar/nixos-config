#!/usr/bin/env bash
# ~/.config/eww/scripts/musica-progreso.sh
# Devuelve 0-100 con la posición actual de la canción

POSICION=$(playerctl position 2>/dev/null) || { echo "0"; exit; }
DURACION=$(playerctl metadata mpris:length 2>/dev/null) || { echo "0"; exit; }

# La duración viene en microsegundos
if [ -z "$DURACION" ] || [ "$DURACION" = "0" ]; then
  echo "0"
  exit
fi

# Convertir duración a segundos
DURACION_SEG=$(echo "$DURACION" | awk '{printf "%.2f", $1/1000000}')

# Calcular porcentaje
echo "$POSICION $DURACION_SEG" | awk '{
  if ($2 > 0) printf "%.0f", ($1/$2)*100
  else print "0"
}'
