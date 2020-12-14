#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: google-containers/busybox $((365 * 4))
#  args: gcr.io/google-containers/busybox $((365 * 4))
#
#  Author: Hari Sekhon
#  Date: 2020-12-14 12:13:34 +0000 (Mon, 14 Dec 2020)
#
#  https://github.com/HariSekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Deletes tags old than N days for a given GCR image

to clean out old CI image builds to save GCS storage costs on old CI images you no longer use


See Also:

    gcr_tags_old.sh        - used by this script, lists all image:tag older than N days
    gcr_tags_timestamps.sh - lists tags and timestamps - useful for comparing with the output from gcr_tags_old.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<image> <days_threshold>"

help_usage "$@"

num_args 2 "$@"

"$srcdir/gcr_tags_old.sh" "$@" |
xargs gcloud container images delete -q --force-delete-tags