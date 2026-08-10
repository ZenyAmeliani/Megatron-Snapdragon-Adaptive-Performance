#!/system/bin/sh

MODDIR=${0%/*}
LOGFILE="$MODDIR/megatron.log"

log_msg() {
    echo "[Megatron] $1" >> "$LOGFILE"
}

# Wait until Android has finished booting
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

sleep 5

log_msg "Megatron Snapdragon Adaptive Performance started"

# Detect Qualcomm Snapdragon
SOC="$(getprop ro.soc.manufacturer)"
MODEL="$(getprop ro.soc.model)"

if [ "$SOC" = "Qualcomm" ] || echo "$MODEL" | grep -qi "snapdragon"; then
    log_msg "Qualcomm Snapdragon detected: $MODEL"
else
    log_msg "Non-Qualcomm device detected - safe mode"
    exit 0
fi

# Detect available CPU governors
for GOV in /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors; do
    [ -f "$GOV" ] || continue
    log_msg "Governor capability found: $GOV"
done

# Prefer schedutil when the kernel explicitly supports it.
for POLICY in /sys/devices/system/cpu/cpufreq/policy*; do
    [ -d "$POLICY" ] || continue

    GOV_FILE="$POLICY/scaling_available_governors"
    SET_GOV="$POLICY/scaling_governor"

    if [ -f "$GOV_FILE" ] && [ -w "$SET_GOV" ]; then
        if grep -qw "schedutil" "$GOV_FILE"; then
            echo schedutil > "$SET_GOV" 2>/dev/null
            log_msg "schedutil selected for $POLICY"
        fi
    fi
done

# Detect Adreno / KGSL
if [ -d /sys/class/kgsl ]; then
    log_msg "Qualcomm KGSL/Adreno detected"
else
    log_msg "KGSL not available - skipping GPU tuning"
fi

# Detect supported I/O schedulers without forcing an unsupported value
for SCHED in /sys/block/*/queue/scheduler; do
    [ -f "$SCHED" ] || continue
    log_msg "I/O scheduler capability: $SCHED"
done

# Memory information
if [ -r /proc/meminfo ]; then
    MEM="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
    log_msg "RAM detected: ${MEM} kB"
fi

log_msg "Megatron initialization completed"
exit 0
