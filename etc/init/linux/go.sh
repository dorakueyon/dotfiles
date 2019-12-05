#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if has "go"; then
  log_pass "go: already installed"
  exit
fi

case "$(get_os)" in
  # Case of OS X
  osx)
  if has "brew"; then
    if brew install go; then
      log_pass "go: installed successfully"
    else
      log_fail "go: failed to install golang"
      exit 1
    fi
  else
    log_fail "error: require: Homebrew"
    exit 1
  fi
  ;;

  # Case of Linux
  linux)
    if has "yum"; then
      log_echo "Install go with Yellowdog Updater Modified"
      sudo yum -y install go
    elif has "apt-get"; then
        log_echo "Install go with Advanced Packaging Tool"
        sudo apt-get -y install go
    elif has "apk"; then
        log_echo "Install go with apk"
        sudo apk add --no-cache go
	elif has "pacman"; then
         log_echo "Install go with pacman"
		pacman -S --noconfirm go
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

log_pass "go: installed successfully"
