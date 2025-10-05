# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
## BEGIN ANSIBLE MANAGED BLOCK ##
# *************************************************************************
#
# Script to print useful system information on login.
#
# Requirements:
#   - 'tput' and 'figlet' must be installed.
#
# Usage:
#   Append the content of this file to your .bashrc.
#
# *************************************************************************
# Resources:
#   - Symbols: https://unicode-table.com/en/sets/arrow-symbols/
#   - Bash colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# *************************************************************************
OS=$(lsb_release -si)
OS_RELEASE=$(lsb_release -sc)
OS_VERSION=$(grep "VERSION_ID" < /etc/os-release | cut -c 13-17)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up//')
ColorReset='\e[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\e[93m'
Blue='\E[1;34m'
Dim='\e[2m'
Bold=$(tput bold)
Normal=$(tput sgr0)

function resourcesInfo() {
    echo -e -n "$Dim[Res-Info]"
    USED_SPACE=$(df -H / |  awk '{print $5 }' | sed -e /^Use/d | sed 's/%//' | cut -d "." -f 1)
    SPACE_VERBOSE=$(df -H / |  awk '{print $5 " "$3" of "$2}' | sed -e /^Use/d)
    # I want to perform arithmetic comparison, bash doesn't work with floating points, hence the 'cut' command.
    MEMORY=$(grep MemAvailable < /proc/meminfo | awk '{print $2/1024}' | cut -d "." -f 1)
    LOAD=$(awk '{print "~5 min=" $2}' < /proc/loadavg)

    echo -e -n "$ColorReset""➜ [$Bold$Dim Load Average$ColorReset$Normal$Yellow$Dim $LOAD $ColorReset "

    if [[ $MEMORY -lt 2048 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Red ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Green ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    fi

    if [[ $USED_SPACE -gt 75 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Red ◉ $SPACE_VERBOSE $ColorReset]"
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Green ◉ $SPACE_VERBOSE $ColorReset]"
    fi

}

function LoggedInUsers () {
    # Get logged in users from tty entry:
    echo -e -n "$Dim[Users-In]"
    # (NR>2) tells awk to skip two header lines
    # sort  and  uniq  to remove duplicate users
    # last sed is to trim/prevent printing whitespaces
    TTY_USERS=$(w | awk '(NR>2) { print $1 }' | sort | uniq | sed '/^[[:space:]]*$/d')

    # Using echo here to print mutiline stdout in a single line via flags: -n and -e
    # To handle a multi-user log in situation. More than one IP will be sent out to stdout from the 'w' command.
    # ->> awk explanation: skip two headers, print third column, sort, get unique IPs, trim space lines
    TTY_IP=$(echo -n -e "$(w | awk '(NR>2) { print $3 }' | sort | uniq | sed '/^[[:space:]]*$/d')")

    echo -e -n "$ColorReset""➜ [$Bold$Dim$ColorReset$Normal$Blue $TTY_USERS$ColorReset$Dim from $Blue$TTY_IP$ColorReset ]"
}

function serviceStatus () {
    IS_ACTIVE=$(systemctl is-active "$1")
    IS_UP=$(systemctl show -p SubState --value "$1")
    if [ "$IS_ACTIVE" = "active" ] ; then
    echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Green ✓$ColorReset$Dim active "

        case $IS_UP in
            "running") echo -e -n "$Green▲$ColorReset$Dim up$Normal$ColorReset ]" ;;
            "dead") echo -e -n "$Red▼$ColorReset$Dim down$ColorReset ]" ;;
            *) echo -e -n "Error loading service" ;;
        esac

    elif [ "$IS_ACTIVE" = "inactive" ] ; then
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Red ✗ $ColorReset inactive ] "

    else
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Yellow ● $ColorReset no status! ] "
    fi
}


function sysInfo() {
   echo -e -n "$Dim[Sys-Info]"
   echo -e -n "$ColorReset""➜ [$Dim Uptime$Blue$UPTIME$ColorReset$Dim ★ Kernel$Blue $KERNEL$ColorReset$Dim ★ $OS $Blue$OS_RELEASE-$OS_VERSION $ColorReset] "
}

figlet -w 120 -f slant -k "$HOSTNAME"
LoggedInUsers
echo ""
sysInfo
echo ""
resourcesInfo
echo ""
echo -e -n "$Dim[Services]"
serviceStatus docker
serviceStatus ssh
echo -e "$ColorReset"

# *************************************************************************
## END ANSIBLE MANAGED BLOCK ##
