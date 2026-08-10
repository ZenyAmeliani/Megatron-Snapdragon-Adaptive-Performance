#!/system/bin/sh

SKIPUNZIP=0

ui_print "========================================"
ui_print " Megatron Snapdragon Adaptive Performance"
ui_print " Version 1.0"
ui_print " Developer: MoccaMocci"
ui_print "========================================"
ui_print "- Preparing installation..."

# Basic Android/root environment check
if [ ! -d /system ] && [ ! -d /data ]; then
    ui_print "! Android environment not detected."
fi

# Detect architecture
ARCH=$(getprop ro.product.cpu.abi 2>/dev/null)

case "$ARCH" in
    arm64-v8a)
        ui_print "- Architecture: ARM64"
        ;;
    armeabi-v7a)
        ui_print "- Architecture: ARM32"
        ;;
    *)
        ui_print "- Architecture: $ARCH"
        ;;
esac

# Detect Qualcomm/Snapdragon
SOC=$(getprop ro.soc.model 2>/dev/null)
[ -z "$SOC" ] && SOC=$(getprop ro.board.platform 2>/dev/null)

if echo "$SOC" | grep -qiE 'qcom|qualcomm|sm[0-9]|sdm[0-9]|msm[0-9]|kona|lahaina|kalama|pineapple'; then
    ui_print "- Qualcomm/Snapdragon platform detected."
else
    ui_print "- Platform: $SOC"
    ui_print "- Adaptive detection will verify supported interfaces at boot."
fi

ui_print "- No CPU/GPU overclock is installed."
ui_print "- Thermal protection is not disabled."
ui_print "- Unsupported kernel interfaces will be skipped."
ui_print "- Installation preparation complete."
ui_print "========================================"
