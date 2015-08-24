#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git yad hicolor_icon_theme

# I run this from i3 like this:
# exec --no-startup-id /home/nafai/Projects/local-nix/check-channel-update.sh --loop
set -o errexit
set -o nounset
set -o pipefail

readonly UPDATE_MESSAGE="New channel update!"
readonly CHECK_FREQUENCY="1h"

# Check out the channels repo with the channel you are running, like:
# git clone --depth=1 --branch=nixos-unstable \
#     git@github.com:NixOS/nixpkgs-channels.git
readonly CHANNELS_DIR="${HOME}/Projects/nix/nixpkgs-channels"
readonly LOCAL_VERSION=$(nixos-version | sed 's/.*\.\([^ ]*\) .*/\1/')

check_for_update() {
    cd "${CHANNELS_DIR}"
    local FULL_LOCAL_CURRENT_SHA1=$(git rev-parse "${LOCAL_VERSION}")

    git pull -q
    local CHANNEL_CURRENT_SHA1=$(git rev-parse HEAD)

    if [ "${FULL_LOCAL_CURRENT_SHA1}" != "${CHANNEL_CURRENT_SHA1}" ]; then
        # If we are running interactively or
        # from where an X display isn't available
        if tty -s || [ ! -v DISPLAY ] ; then
            echo "${UPDATE_MESSAGE}"
        else
            yad --notification \
                --image="software-update-available" \
                --text="${UPDATE_MESSAGE}"
        fi
    fi
}

main () {
    [[ $# -gt 0 && "$1" == "--loop" ]] &&
        readonly local loop_infinitely=true || loop_infinitely=false

    while true; do
        check_for_update

        if [ "$loop_infinitely" = "true" ]; then
            sleep "$CHECK_FREQUENCY"
        else
            break
        fi
    done
}

main "$@"
