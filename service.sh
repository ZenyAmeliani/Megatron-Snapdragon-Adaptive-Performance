#!/system/bin/sh
MODDIR="${0%/*}"
LOG="$MODDIR/megatron.log"
echo "[Megatron] service started" >> "$LOG"
until [ "$(getprop sys.boot_completed 2>/dev/null)" = "1" ]; do sleep 2; done
sleep 5
[ -f "$MODDIR/engine.sh" ] && /system/bin/sh "$MODDIR/engine.sh"
exit 0
