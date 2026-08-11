#!/system/bin/sh
SKIPUNZIP=0
# Ensure module helper scripts remain executable on all supported installs.
chmod 0755 "$MODPATH"/*.sh 2>/dev/null
ui_print "========================================"
ui_print " Megatron Snapdragon Adaptive Performance"
ui_print " Version 1.1"
ui_print " Developer: MoccaMocci"
ui_print "========================================"
ui_print "- WebUI runtime fixed"
ui_print "- Adaptive Snapdragon detection improved"
ui_print "- Thermal protection remains enabled"
ui_print "- Unsupported kernel nodes are skipped"
ui_print "========================================"
