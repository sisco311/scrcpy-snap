#!/usr/bin/env bash
# Pull the scrcpy-server part, which has to be the same version with the main
# part
#
# Copyright 2024 林博仁(Buo-ren, Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: Apache-2.0

# The version of prebuilt scrcpy-server to pull
SCRCPY_SERVER_VERSION="${SCRCPY_SERVER_VERSION:-latest}"

set_opts=(
    # Terminate script execution when an unhandled error occurs
    -o errexit

    # Terminate script execution when an unset parameter variable is
    # referenced
    -o nounset
)
if ! set "${set_opts[@]}"; then
    printf \
        'Error: Unable to configure the defensive interpreter behaviors.\n' \
        1>&2
    exit 1
fi

trap_err(){
    printf \
        'Error: The program prematurely terminated due to an unhandled error.\n' \
        1>&2
    exit 99
}
if ! trap trap_err ERR; then
    printf \
        'Error: Unable to set the ERR trap.\n' \
        1>&2
    exit 1
fi

if test "${SCRCPY_SERVER_VERSION}" != latest; then
    pull_release_tag="v${SCRCPY_SERVER_VERSION}"
else
    printf 'Querying the release tags from the GitHub REST API...\n'
    curl_opts=(
        # Follow redirects
        --location

        # Return non-zero exit status when receiving an error HTTP status code
        --fail

        --header "Accept: application/vnd.github+json"
        --header "X-GitHub-Api-Version: 2022-11-28"
    )
    if ! release_tags_raw="$(
        curl \
            "${curl_opts[@]}" \
            https://api.github.com/repos/Genymobile/scrcpy/git/matching-refs/tags/v
        )"; then
        printf \
            'Error: Unable to query the release tags from the GitHub REST API.\n' \
            1>&2
        exit 2
    fi

    printf \
        'Parsing out the release tags from the GitHub REST API response...\n'
    jq_opts=(
        # Avoid quoting output
        --raw-output
    )
    if ! release_tags="$(jq "${jq_opts[@]}" .[].ref <<<"${release_tags_raw}")"; then
        printf \
            'Error: Unable to parse out the release tags from the GitHub REST API response.\n' \
            1>&2
        exit 2
    fi

    printf 'Filtering out invalid release tags...\n'
    grep_opts=(
        --extended-regexp
        --regexp='-install-release$'
        --invert-match
    )
    if ! release_tags="$(grep "${grep_opts[@]}" <<<"${release_tags}")"; then
        printf 'Error: Unable to filter out invalid release tags.\n' 1>&2
        exit 2
    fi

    printf 'Determining the Git reference of the latest release tag...\n'
    if ! latest_release_tag_reference="$(tail --lines=1 <<<"${release_tags}")"; then
        printf \
            'Error: Unable to determine the Git reference of the latest release tag.\n' \
            1>&2
        exit 2
    fi

    printf 'Determining the latest release tag...\n'
    latest_release_tag="${latest_release_tag_reference##*/}"
    printf 'Latest release tag determined to be "%s".\n' "${latest_release_tag}"
    pull_release_tag="${latest_release_tag}"
fi

pull_version="${pull_release_tag#v}"

printf 'Downloading the %s version of the scrcpy-server package...\n' "${pull_version}"
curl_opts=(
    # Follow redirects
    --location

    # Return non-zero exit status when receiving an error HTTP status code
    --fail

    # Use the filename instructed from the HTTP response header
    --remote-name
    --remote-header-name
)
server_package_url="https://github.com/Genymobile/scrcpy/releases/download/${pull_release_tag}/scrcpy-server-${pull_release_tag}"
if ! curl "${curl_opts[@]}" "${server_package_url}"; then
    printf \
        'Error: Unable to download the %s version of the pre-built scrcpy-server package.\n' \
        "${pull_release_tag}" \
        1>&2
    exit 2
fi

printf 'Operation completed without errors.\n'
