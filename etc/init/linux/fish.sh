#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have Z shell or don't find fish preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "fish"; then

    # Install fish
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install fish with Homebrew"
                brew install fish
            elif "port"; then
                log_echo "Install fish with MacPorts"
                sudo port install fish-devel
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install fish with Yellowdog Updater Modified"
                sudo yum -y install fish
            elif has "apt-get"; then
                log_echo "Install fish with Advanced Packaging Tool"
                sudo apt-get -y install fish
            elif has "apk"; then
                log_echo "Install fish with apk"
                sudo apk -y add --no-cache fish
			elif has "pacman"; then
                log_echo "Install fish with pacman"
				pacman -S --noconfirm fish
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
# Run the forced termination with a last exit code
#exit $?

# Assign fish as a login shell
if ! contains "${SHELL:-}" "fish"; then
    fish_path="$(which fish)"

    if [ -x "$fish_path" ]; then
        if has "chsh"; then
			# Changing for a general user

			if chsh -s "$fish_path" "${USER:-root}"; then
				log_pass "Change shell to $fish_path for ${USER:-root} successfully"
			else
				log_fail "cannot set '$path' as \$SHELL"
				log_fail "Is '$path' described in /etc/shells?"
				log_fail "you should run 'chsh -l' now"
				exit 1
			fi

			# For root user
			if [ ${EUID:-${UID}} = 0 ]; then
				if chsh -s "$fish_path" && :; then
					log_pass "[root] change shell to $fish_path successfully"
				fi
			fi
		fi
    else
        log_fail "$fish_path: invalid path"
        exit 1
    fi
fi
