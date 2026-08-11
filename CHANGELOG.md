# Megatron Snapdragon Adaptive Performance

## Version 1.2.0
- Redesigned WebUI with Megatron performance artwork background.
- Added dynamic Engine / Profile / Thermal / CPU Policy / GPU / Status panel.
- Thermal protection remains active.
- Improved user feedback after profile application.

# Megatron Snapdragon Adaptive Performance

## Version 1.1.1
- Fixed profile activation when helper script executable permissions are not preserved.
- WebUI now invokes apply/engine through `/system/bin/sh`.
- Installer explicitly restores executable permissions for module shell scripts.
- Thermal protection remains enabled.

# Megatron Snapdragon Adaptive Performance

## Version 1.1
- Fixed WebUI JavaScript loading by using a local KernelSU bridge module.
- Fixed profile buttons and refresh detection interaction.
- Added WebUI timeout/error handling and clearer status messages.
- Improved Qualcomm/Snapdragon detection using SoC, board platform and hardware properties.
- Added safe profile application helper.
- Thermal protection remains enabled.
- Unsupported kernel interfaces are skipped.

## Version 1.0
- Initial public release.
