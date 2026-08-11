#!/system/bin/sh
MODDIR="${0%/*}"
LOG="$MODDIR/megatron.log"
DETECT="$MODDIR/meg_detect.env"
CONFIG="$MODDIR/config.sh"

log(){ [ "${LOG_ENABLED:-1}" = "1" ] && echo "$(date '+%H:%M:%S' 2>/dev/null) [Megatron] $*" >> "$LOG"; }
write_if_supported(){
  NODE="$1"; VALUE="$2"
  [ -e "$NODE" ] && [ -w "$NODE" ] || return 0
  printf '%s' "$VALUE" > "$NODE" 2>/dev/null || return 0
  log "Applied $NODE=$VALUE"
}

[ -r "$CONFIG" ] && . "$CONFIG"
[ -x "$MODDIR/detect.sh" ] && "$MODDIR/detect.sh"
[ -r "$DETECT" ] && . "$DETECT"

case "${PROFILE:-balanced}" in balanced|performance|gaming|extreme) ;; *) PROFILE=balanced ;; esac
log "Engine start: SoC=${MEG_SOC:-unknown}, profile=$PROFILE"

if [ "${MEG_IS_QUALCOMM:-0}" != "1" ]; then
  log "Qualcomm/Snapdragon not confirmed; safe exit"
  exit 0
fi

for POLICY in /sys/devices/system/cpu/cpufreq/policy*; do
  [ -d "$POLICY" ] || continue
  GOV="$POLICY/scaling_governor"
  AVAIL="$POLICY/scaling_available_governors"
  [ -r "$AVAIL" ] && [ -w "$GOV" ] || continue
  case "$PROFILE" in
    balanced)
      grep -qw schedutil "$AVAIL" && write_if_supported "$GOV" schedutil
      ;;
    performance|gaming|extreme)
      if grep -qw performance "$AVAIL"; then
        write_if_supported "$GOV" performance
      elif grep -qw schedutil "$AVAIL"; then
        write_if_supported "$GOV" schedutil
      fi
      ;;
  esac
done

GPU="/sys/class/kgsl/kgsl-3d0"
if [ -d "$GPU" ] && [ -r "$GPU/devfreq/available_governors" ] && [ -w "$GPU/devfreq/governor" ]; then
  AVAIL_GPU="$GPU/devfreq/available_governors"
  if grep -qw msm-adreno-tz "$AVAIL_GPU"; then
    write_if_supported "$GPU/devfreq/governor" msm-adreno-tz
  elif grep -qw simple_ondemand "$AVAIL_GPU"; then
    write_if_supported "$GPU/devfreq/governor" simple_ondemand
  fi
fi

log "Thermal zones=${MEG_THERMAL_ZONES:-0}; thermal protection untouched"
log "Profile applied: $PROFILE"
exit 0
