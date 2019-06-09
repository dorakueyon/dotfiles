#          _              
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#                         
#

umask 022
limit coredumpsize 0
bindkey -d

#  It is necessary for the setting of DOTPATH
if [[ -f ~/.path ]]; then
  source ~/.path
else
  export DOTPATH="${0:A:t}"
fi
# export DOTPATH='/Users/yoheia/dotfiles'

# DOTPATH environment variable specifies the location of dotfiles.
# On Unix, the value is a colon-separated string. On Windows,
# it is not yet supported.
# DOTPATH must be set to run make init, make test and shell script library
# outside the standard dotfiles tree.
if [[ -z $DOTPATH ]]; then
  echo "$fg[red]cannot start ZSH, \$DOTPATH not set$reset_color" 1>&2
  return 1
fi

# Vital
# vital.sh script is most important file in this dotfiles.
# This is because it is used as installation of dotfiles chiefly and as shell
# script library vital.sh that provides most basic and important functions.
# As a matter of fact, vital.sh is a symbolic link to install, and this script
# change its behavior depending on the way to have been called.
export VITAL_PATH="$DOTPATH/etc/lib/vital.sh"
if [[ -f $VITAL_PATH ]]; then
  source "$VITAL_PATH"
fi


# Setting importing from bash_profile.
# following setting will be deleted after making separated file.
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH=${PYENV_ROOT}/bin:$PATH
  eval "$(pyenv init -)"
fi

export ENHANCD_FILTER="fzy:$ENHANCD_FILTER"

# Exit if called from vim
[[ -n $VIMRUNTIME ]] && return

# Check whether the vital file is loaded
if ! vitalize 2>/dev/null; then
  echo "$fg[red]cannot vitalize$reset_color" 1>&2
  return 1
fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
$DOTPATH/bin/tmuxx

if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
    source ~/.zplug/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
    fi
    zplug load
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi




# Display Zsh version and display number
printf "\n$fg_bold[cyan]This is ZSH $fg_bold[red]${ZSH_VERSION}"
printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n\n"

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:


eval "$(rbenv init - zsh)"

# prompt
#PROMPT='[%F{magenta}%B%n%b%f@%F{blue}%U%m%u%f]# '
PROMPT='[%F{yellow}%B%n%b%f]%% '
#RPROMPT='at [%F{green}%d%f]'
rpromptpwd='at [%F{green}%d%f]'

# vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats '%F{green}[%s] %c%u%b%f'
zstyle ':vcs_info:*' actionformats '%F{red}[%s]%c%u%b|%a%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_} ${rpromptpwd}"
}
add-zsh-hook precmd _update_vcs_info_msg
