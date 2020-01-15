# Colors CLEAR='\e[0m'
CYAN='\e[36m'
GREEN='\e[32m'
YELLOW='\e[33m'

# Functions
function compressed_working_path {
  # Use sed to perform string replacement on pwd
  pwd | sed 's#\([^/]\{1,3\}\)[^/]*/#\1/#g'
}

function echo_local_ruby {
  echo "Ruby version $(rbenv local)"
}

function git_status_color {
  # Test `[' with -z flag to test string length, evaluating "$()" to a string
  if [ -z "$(git status --porcelain 2> /dev/null)" ]; then
    printf $GREEN
  else
    printf $YELLOW
  fi
}

function toggle_autotomy_branch {
  if [ -z "$(git name-rev HEAD 2> /dev/null | grep master)" ]; then
    git checkout master
    if [ $? == 0 ]; then
      unset RBENV_VERSION
      echo_local_ruby 
    fi
  else
    git checkout ndx_support
    if [ $? == 0 ]; then
      touch .ruby-version
      rbenv local 2.4.2
      echo_local_ruby 
    fi
  fi
}

function make_and_change_dir {
  # Some special variables starting with `$' are always available; $1 is the first argument passed
  mkdir $1
  cd $1
}

function parse_git_branch {
  # Redirecting output from stderr to a nonexistent file (/dev/null); then piping the actual stdout
  git branch 2> /dev/null | awk '/\*/ { print $2; }'
}

# Aliases
alias autotune='toggle_autotomy_branch'
alias be='bundle exec'
alias ll='ls -alhH'
alias mcd='make_and_change_dir'
alias mp='mpw -F none'
alias mzn='minizinc --solver Gecode'
alias so='source'
alias static='python -m SimpleHTTPServer 8080'

# Git
test -f ~/.git-completion.bash && source $_
export GPG_TTY=$(tty)

# Prompt
PS1="\[$CYAN\]\$(compressed_working_path)\[$GREEN\]:\[\$(git_status_color)\]\$(parse_git_branch)\[$GREEN\]\$\[\e[0m\] "

# Ruby
eval "$(rbenv init -)"

# Python and pip
USER_BASE_PATH=$(python -m site --user-base)
export PATH="$PATH:$USER_BASE_PATH/bin"

# Node
eval "$(nodenv init -)"
export PATH="./node_modules/.bin:./bin:$PATH"

# Strap
STRAP_BIN_DIR=~/src/strap/bin
if [ -d $STRAP_BIN_DIR ]; then
  PATH="$STRAP_BIN_DIR:${PATH}"
fi

# General
export EDITOR='vim'
export VISUAL='vim'

# OPAM configuration
. /Users/jason.hinebaugh/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# AWS Kinesis needs bison
export PATH="/usr/local/opt/bison/bin:$PATH"

# MiniZinc CLI bundled with MiniZinc IDE
export PATH="/Applications/MiniZincIDE.app/Contents/Resources:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"
