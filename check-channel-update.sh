#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Check out the channels repo with the channel you are running, like:
# git clone --depth=1 --branch=nixos-unstable git@github.com:NixOS/nixpkgs-channels.git
readonly CHANNELS_DIR="${HOME}/Projects/nix/nixpkgs-channels"
readonly LOCAL_VERSION=$(nixos-version | sed 's/.*\.\([^ ]*\) .*/\1/')

cd "${CHANNELS_DIR}"
git pull -q

readonly FULL_LOCAL_CURRENT_SHA1=$(git rev-parse "${LOCAL_VERSION}")
readonly CHANNEL_CURRENT_SHA1=$(git rev-parse HEAD)

[ "${FULL_LOCAL_CURRENT_SHA1}" != "${CHANNEL_CURRENT_SHA1}" ] &&
    echo "New channel update!"
