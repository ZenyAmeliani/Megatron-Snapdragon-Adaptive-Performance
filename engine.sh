#!/system/bin/sh

MODDIR=${0%/*}
LOGFILE="$MODDIR/megatron.log"

log() {
    echo "[Megatron Engine] $1" >> "$LOGFILE"
}

# =========================================================
# Megatron Snapdragon Adaptive Performance Engine
# Version 1.0
# Developer: MoccaMocci
# =========================================================

log "Engine initialization"

# ---------------------------------------------------------
# CPU POLICY DETECTION
# ---------------------------------------------------------

for POLICY in /sys/devices/system/cpu/cpufreq/policy*; do
    [ -d "$POLICY" ] || continue

    GOV="$POLICY/scaling_governor"
    AVAIL="$POLICY/scaling_available_governors"

    if [ -f "$AVAIL" ] && [ -w "$GOV" ]; then

        if grep -qw "schedutil" "$AVAIL"; then
            echo "schedutil" > "$GOV" 2>/dev/null
            log "schedutil enabled: $POLICY"

        elif grep -qw "interactive" "$AVAIL"; then
            echo "interactive" > "$GOV" 2>/dev/null
            log "interactive enabled: $POLICY"

        else
            log "Kernel governor left unchanged: $POLICY"
        fi
    fi
done

# ---------------------------------------------------------
# CPU BOOST CAPABILITY DETECTION
# ---------------------------------------------------------

if [ -e /sys/devices/system/cpu/cpufreq/boost ]; then
    log "CPU boost interface detected"
fi

if [ -e /sys/devices/system/cpu/cpufreq/cpuinfo_max_freq ]; then
    log "CPU frequency interface detected"
fi

# ---------------------------------------------------------
# GPU DETECTION
# ---------------------------------------------------------

if [ -d /sys/class/kgsl ]; then
    log "Qualcomm Adreno / KGSL detected"

    if [ -d /sys/class/kgsl/kgsl-3d0 ]; then
        log "Adreno GPU node detected"
    fi
else
    log "KGSL unavailable - GPU tuning skipped"
fi

# ---------------------------------------------------------
# I/O DETECTION
# ---------------------------------------------------------

for SCHED in /sys/block/*/queue/scheduler; do
    [ -f "$SCHED" ] || continue

    DEVICE=$(echo "$SCHED" | cut -d/ -f4)

    if grep -qw "mq-deadline" "$SCHED"; then
        log "mq-deadline available: $DEVICE"
    elif grep -qw "none" "$SCHED"; then
        log "none scheduler available: $DEVICE"
    else
        log "I/O scheduler detected: $DEVICE"
    fi
done

# ---------------------------------------------------------
# MEMORY DETECTION
# ---------------------------------------------------------

if [ -r /proc/meminfo ]; then
    RAM_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    RAM_MB=$((RAM_KB / 1024))

    log "RAM detected: ${RAM_MB} MB"
fi

# ---------------------------------------------------------
# SOC INFORMATION
# ---------------------------------------------------------

SOC_MANUFACTURER=$(getprop ro.soc.manufacturer)
SOC_MODEL=$(getprop ro.soc.model)

log "SoC manufacturer: $SOC_MANUFACTURER"
log "SoC model: $SOC_MODEL"

# ---------------------------------------------------------
# SAFETY
# ---------------------------------------------------------

log "No unsupported frequency or voltage values forced"
log "Adaptive engine initialization completed"

exit 0
