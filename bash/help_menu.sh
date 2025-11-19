#!/usr/bin/env bash
# set -x  # <-- ENABLE DEBUG STATEMENTS.
[[ -n "$DEBUG" ]] && set -x  # <-- ENABLE DEBUG STATEMENTS.

# source: https://www.howtogeek.com/beginner-friendly-ways-to-level-up-your-bash-scripts/

_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

OPTIONS
  -h     display this help menu
  -r     do NOT press this button
  -a     echo something

EXAMPLES
  ./help_menu.sh -a emmerson
  ./help_menu.sh -h
  DEBUG=true ./help_menu.sh -a emmerson

EOF
}

# Check if no options were passed
if [ $OPTIND -eq 1 ]; then echo "No options were passed"; _help; exit 1;fi

# Parse command line options
while getopts "ra:h" opt; do
  case "$opt" in
  r)
    curl 'https://ascii.live/rick'
    ;;
  a)
    echo "PARAMETER -$opt: $OPTARG" # For example, "ECHO -a: foo"
    ;;
  h)
    _help
    exit 0
    ;;
  ?)
    _help
    exit 0
    ;;
  *)
    _help
    exit 0
    ;;
  esac
done