#!/usr/bin/env bash
# ~/.config/eww/scripts/pomodoro.sh
# Gestiona el estado del timer Pomodoro
# Uso: pomodoro.sh [start|pause|reset|status|tick]
# Estado persistido en ~/.local/share/eww-pomodoro

STATE_FILE="$HOME/.local/share/eww-pomodoro"
WORK_SECS=1500   # 25 minutos
BREAK_SECS=300   # 5 minutos

init_state() {
  mkdir -p "$(dirname "$STATE_FILE")"
  if [[ ! -f "$STATE_FILE" ]]; then
    echo "stopped|work|$WORK_SECS|0" > "$STATE_FILE"
  fi
}

read_state() {
  IFS='|' read -r STATUS MODE REMAINING SESSIONS < "$STATE_FILE"
}

write_state() {
  echo "${STATUS}|${MODE}|${REMAINING}|${SESSIONS}" > "$STATE_FILE"
}

format_time() {
  local secs=$1
  printf "%02d:%02d" $((secs / 60)) $((secs % 60))
}

case "${1:-status}" in
  start)
    init_state
    read_state
    STATUS="running"
    write_state
    ;;

  pause)
    init_state
    read_state
    if [[ "$STATUS" == "running" ]]; then
      STATUS="paused"
    else
      STATUS="running"
    fi
    write_state
    ;;

  reset)
    init_state
    read_state
    STATUS="stopped"
    MODE="work"
    REMAINING=$WORK_SECS
    write_state
    ;;

  skip)
    init_state
    read_state
    if [[ "$MODE" == "work" ]]; then
      SESSIONS=$((SESSIONS + 1))
      MODE="break"
      REMAINING=$BREAK_SECS
    else
      MODE="work"
      REMAINING=$WORK_SECS
    fi
    STATUS="stopped"
    write_state
    ;;

  tick)
    # Llamado cada segundo por el defpoll de Eww
    init_state
    read_state
    if [[ "$STATUS" == "running" ]]; then
      REMAINING=$((REMAINING - 1))
      if [[ "$REMAINING" -le 0 ]]; then
        # Timer completado — cambiar modo
        if [[ "$MODE" == "work" ]]; then
          SESSIONS=$((SESSIONS + 1))
          MODE="break"
          REMAINING=$BREAK_SECS
          notify-send -u normal -i clock "Pomodoro" "¡Descanso! 5 minutos." 2>/dev/null || true
        else
          MODE="work"
          REMAINING=$WORK_SECS
          notify-send -u normal -i clock "Pomodoro" "¡A trabajar! 25 minutos." 2>/dev/null || true
        fi
        STATUS="stopped"
      fi
      write_state
    fi
    ;;

  status)
    init_state
    read_state
    # Emitir JSON para Eww
    TIME_FMT=$(format_time "$REMAINING")
    PROGRESS=$(( (( MODE == "work" ? WORK_SECS : BREAK_SECS ) - REMAINING) * 100 / ( MODE == "work" ? WORK_SECS : BREAK_SECS ) ))
    echo "{\"status\":\"$STATUS\",\"mode\":\"$MODE\",\"time\":\"$TIME_FMT\",\"progress\":$PROGRESS,\"sessions\":$SESSIONS}"
    ;;
esac
