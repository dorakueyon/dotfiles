#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have find neovim preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "neovim"; then

    # Install neovim
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install neovim with Homebrew"
				brew install neovim
            elif "port"; then
                log_echo "Install neovim with MacPorts"
				sudo port selfupdate
				sudo port install neovim
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install neovim with Yellowdog Updater Modified"
				yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
				yum install -y neovim python3-neovim
            elif has "apt-get"; then
                log_echo "Install neovim with Advanced Packaging Tool"
                sudo apt-get -y install neovim
            elif has "apk"; then
                log_echo "Install neovim with apk"
                sudo apk -y add --no-cache neovim
			elif has "pacman"; then
                log_echo "Install neovim with pacman"
				pacman -S --noconfirm neovim
				pacman -S --noconfirm python3
				pacman -S --noconfirm python-pip
				pacman -S --noconfirm gcc
				pip install neovim
            else
                log_fail "error: require: YUM, APT, APK or PACMAN"
                exit 1
            fi
            ;;

        # Other platforms such as BSD are supported
        *) log_fail "error: this script is only supported osx and linux"
            exit 1
            ;;
    esac
fi
# Run the forced termination with a last exit code
#exit $?
