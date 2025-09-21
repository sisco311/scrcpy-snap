#!/usr/bin/env bash
# Override the logic of the build step of the scrcpy snapcraft part
#
# Copyright 2025 Buo-ren Lin <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: Apache-2.0

if ! set -eu; then
    printf 'Error: Unable to configure defensive interpreter behaviors.\n' 1>&2
    exit 1
fi

required_commands=(
    craftctl
)
required_command_check_failed=false
for command in "${required_commands[@]}"; do
    if ! command -v "${command}" &>/dev/null; then
        printf 'Error: Required command "%s" not found.\n' "${command}" 1>&2
        required_command_check_failed=true
    fi
done
if test "${required_command_check_failed}" = true; then
    printf 'Error: Required command check failed.\n' 1>&2
    exit 1
fi

if ! craftctl default; then
    printf 'Error: Unable to run the default logic of the build step.\n' 1>&2
    exit 1
fi

printf 'Patching the desktop file icon path...\n'
sed_opts=(
    --in-place

    # Use extended regular expressions in the script
    --regexp-extended

    # Patch icon path to meet Snapcraft expectations
    --expression='s@^Icon=.*@Icon=/usr/local/share/icons/hicolor/256x256/apps/scrcpy.png@'

)
if ! sed "${sed_opts[@]}" \
    "${CRAFT_PART_INSTALL}/usr/local/share/applications/scrcpy.desktop" \
    "${CRAFT_PART_INSTALL}/usr/local/share/applications/scrcpy-console.desktop"; then
    printf 'Error: Unable to patch the icon path of the desktop entry files.\n' 1>&2
    exit 1
fi

printf \
    'Info: Patching the main desktop entry file...\n'
sed_opts=(
    --in-place

    # Use extended regular expressions in the script
    --regexp-extended

    # We don't use the user environment
    --expression='s@^Exec=.*@Exec=scrcpy@'

    # Drop not-applicable user environment comments
    --expression='/^#/d'

    # Append unofficial marking to the Name keys
    --expression='/^Name(\[[^\]]+\])?=/s/$/ (unofficial snap)/'
)
if ! sed "${sed_opts[@]}" \
    "${CRAFT_PART_INSTALL}/usr/local/share/applications/scrcpy.desktop"; then
    printf 'Error: Unable to patch the main desktop entry file.\n' 1>&2
    exit 1
fi

printf \
    'Info: Patching the console desktop entry file...\n'
sed_opts=(
    --in-place

    # Use extended regular expressions in the script
    --regexp-extended

    # We don't use user environment
    --expression='s@^Exec=.*@Exec=scrcpy --pause-on-exit=if-error@'

    # Drop not-applicable user environment comments
    --expression='/^#/d'

    # Append unofficial marking to the Name keys
    --expression='/^Name(\[[^\]]+\])?=/s/$/ (unofficial snap)/'
)
if ! sed "${sed_opts[@]}" \
    "${CRAFT_PART_INSTALL}/usr/local/share/applications/scrcpy-console.desktop"; then
    printf 'Error: Unable to patch the console desktop entry file.\n' 1>&2
    exit 1
fi
