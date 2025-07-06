#!/usr/bin/env bash
# Drop content snap duplicate files
#
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright 2025 Buo-ren Lin <buo.ren.lin@gmail.com>

if ! set -eu; then
    printf 'Error: Unable to configure defensive interpreter behaviors.\n' 1>&2
    exit 1
fi

required_commands=(
    find
    realpath
    rm
    xargs
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

if test "${#}" -ne 1; then
    printf 'Usage: %s <snap-name>\n' "${0}" 1>&2
    exit 1
fi

snap="${1}"
content_snap_dir="/snap/${snap}/current"

if ! test -d "${content_snap_dir}"; then
    printf 'Error: Content snap installation directory "%s" not found.\n' "${content_snap_dir}" 1>&2
    exit 1
fi

if ! mapfile -t content_snap_files < <(
    cd "${content_snap_dir}" \
        && find . \
            -type f,l \
            -print
    ); then
    printf \
        'Error: Unable to enumerate the files and links in the content snap "%s" and store them in the array.\n' \
        "${snap}" \
        1>&2
    exit 2
fi

for file in "${content_snap_files[@]}"; do
    file="${file#./}"

    file_in_prime="${CRAFT_PRIME}/${file}"
    if test -e "${file_in_prime}"; then
        printf \
            'Info: Dropping the duplicate file "%s" of the content snap "%s" from the prime directory...\n' \
            "${file}" \
            "${snap}" \
            1>&2

        rm \
            --force \
            "${file_in_prime}" \
            || true # Will fail if the file is a directory.
    fi
done

printf \
    'Info: Operation completed successfully.\n'
