#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git yad hicolor_icon_theme

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

readonly UPDATE_MESSAGE="New channel update!"

if [ "${FULL_LOCAL_CURRENT_SHA1}" == "${CHANNEL_CURRENT_SHA1}" ]; then
    # If we are running interactively or from where an X display isn't available
    if [ -n "$(tty)" ] || [ ! -v DISPLAY ] ; then
        echo "${UPDATE_MESSAGE}"
    else
        yad --notification --image="software-update-available" --text="${UPDATE_MESSAGE}"
    fi
fi
