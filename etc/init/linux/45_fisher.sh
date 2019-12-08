#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

if ! has "fish"; then
     log_fail "error: require: fish"
     exit 1
fi

# If you don't have find fish preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "fisher"; then
    # Install fisher
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install fisher with Homebrew"
                brew install fisher
            elif "port"; then
                log_echo "Install fisher with MacPorts"
                sudo port install fish-devel
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install fisher with Yellowdog Updater Modified"
                sudo yum -y install fisher
            elif has "apt-get"; then
                log_echo "Install fisher with Advanced Packaging Tool"
                sudo apt-get -y install fisher
            elif has "apk"; then
                log_echo "Install fisher with apk"
                sudo apk -y add --no-cache fisher
			elif has "pacman"; then
                log_echo "Install fisher with pacman"
				pacman -S --noconfirm fisher
            else
                log_fail "error: require: YUM, APT, APK or PACMAN"
                exit 1
            fi
            ;;

        # Other platforms such as BSD are supported
        *)
            log_fail "error: this script is only supported osx and linux"
            exit 1
            ;;
    esac

fi