#!/system/bin/sh
MODDIR="${0%/*}"
OUT="$MODDIR/meg_detect.env"
getp(){ getprop "$1" 2>/dev/null; }

SOC="$(getp ro.soc.model)"
[ -n "$SOC" ] || SOC="$(getp ro.board.platform)"
[ -n "$SOC" ] || SOC="$(getp ro.hardware)"
HARDWARE="$(getp ro.hardware)"
KERNEL="$(uname -r 2>/dev/null)"
ARCH="$(uname -m 2>/dev/null)"
ANDROID="$(getp ro.build.version.release)"
ABI="$(getp ro.product.cpu.abi)"

SOC_LC="$(printf '%s' "$SOC $HARDWARE" | tr '[:upper:]' '[:lower:]')"
IS_QUALCOMM=0
case "$SOC_LC" in
  *qcom*|*qualcomm*|*sm[0-9]*|*sdm[0-9]*|*msm[0-9]*|*lahaina*|*kona*|*waipio*|*kalama*|*pineapple*) IS_QUALCOMM=1 ;;
esac

CPU_COUNT="$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)"
[ -n "$CPU_COUNT" ] || CPU_COUNT=0
GOVERNORS="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 2>/dev/null)"
CURRENT_GOV="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)"
CPU_MAX="$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)"
CPU_MIN="$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq 2>/dev/null)"

GPU_ROOT="/sys/class/kgsl/kgsl-3d0"
GPU_PRESENT=0
[ -d "$GPU_ROOT" ] && GPU_PRESENT=1
GPU_GOVS="$(cat "$GPU_ROOT/devfreq/available_governors" 2>/dev/null)"
GPU_GOV="$(cat "$GPU_ROOT/devfreq/governor" 2>/dev/null)"

MEM_TOTAL="$(awk '/MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null)"
THERMAL_ZONES="$(find /sys/class/thermal -maxdepth 1 -type d -name 'thermal_zone*' 2>/dev/null | wc -l)"

{
  echo "MEG_SOC=$SOC"
  echo "MEG_HARDWARE=$HARDWARE"
  echo "MEG_KERNEL=$KERNEL"
  echo "MEG_ARCH=$ARCH"
  echo "MEG_ANDROID=$ANDROID"
  echo "MEG_ABI=$ABI"
  echo "MEG_IS_QUALCOMM=$IS_QUALCOMM"
  echo "MEG_CPU_COUNT=$CPU_COUNT"
  echo "MEG_CURRENT_GOV=$CURRENT_GOV"
  echo "MEG_CPU_MIN=$CPU_MIN"
  echo "MEG_CPU_MAX=$CPU_MAX"
  echo "MEG_GPU_PRESENT=$GPU_PRESENT"
  echo "MEG_GPU_GOV=$GPU_GOV"
  echo "MEG_GPU_GOVS=$GPU_GOVS"
  echo "MEG_MEM_TOTAL_KB=$MEM_TOTAL"
  echo "MEG_THERMAL_ZONES=$THERMAL_ZONES"
  echo "MEG_GOVERNORS=$GOVERNORS"
  echo "MEG_DETECT_OK=1"
} > "$OUT"
chmod 0644 "$OUT" 2>/dev/null
exit 0
