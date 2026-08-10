#!/system/bin/sh

# =========================================================
# Megatron Snapdragon Adaptive Performance
# Configuration - Version 1.0
# Developer: MoccaMocci
# =========================================================

# Default profile
MEGATRON_PROFILE="BALANCED"

# Available profiles:
# BALANCED
# PERFORMANCE
# GAMING
# EXTREME

# Thermal protection
# 1 = keep Android thermal protection active
# 0 = disable thermal safety (NOT recommended)
MEGATRON_THERMAL_SAFE=1

# Adaptive mode
# 1 = automatically detect supported kernel interfaces
MEGATRON_ADAPTIVE=1

# Do not force unsupported CPU/GPU frequencies
MEGATRON_SAFE_FREQ=1

# Enable logging
MEGATRON_LOG=1

# =========================================================
# Profile description
# =========================================================

case "$MEGATRON_PROFILE" in

    BALANCED)
        MEGATRON_CPU_MODE="balanced"
        MEGATRON_IO_MODE="balanced"
        MEGATRON_MEMORY_MODE="balanced"
        ;;

    PERFORMANCE)
        MEGATRON_CPU_MODE="performance"
        MEGATRON_IO_MODE="performance"
        MEGATRON_MEMORY_MODE="performance"
        ;;

    GAMING)
        MEGATRON_CPU_MODE="gaming"
        MEGATRON_IO_MODE="gaming"
        MEGATRON_MEMORY_MODE="gaming"
        ;;

    EXTREME)
        MEGATRON_CPU_MODE="extreme"
        MEGATRON_IO_MODE="extreme"
        MEGATRON_MEMORY_MODE="extreme"
        ;;

    *)
        # Unknown profile = safe fallback
        MEGATRON_PROFILE="BALANCED"
        MEGATRON_CPU_MODE="balanced"
        MEGATRON_IO_MODE="balanced"
        MEGATRON_MEMORY_MODE="balanced"
        ;;

esac
