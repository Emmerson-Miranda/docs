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
  -p    print passed parameters

EXAMPLES
  ./help_menu.sh -a emmerson
  ./help_menu.sh -h
  ./help_menu.sh -p arg1 arg2 arg3
  DEBUG=true ./help_menu.sh -a emmerson

EOF
}

# Check if no options were passed
if [ "$#" -eq 0 ]; then echo "No options were passed"; _help; exit 1;fi

# Parse command line options
while getopts "r:a:hp" opt; do
  case "$opt" in
  r)
    curl 'https://ascii.live/rick'
    ;;
  a)
    echo "PARAMETER -$opt value $OPTARG" 
    ;;
  h)
    _help
    exit 0
    ;;
  p)
    # Print all passed arguments
    echo "Passed arguments:"
    for arg in "$@"; do
      echo "    argument: ${arg}"
    done
    echo ""
    ;;
  :)
    echo "Option -$opt requires an argument."
    exit 0
    ;;
  *)
    # print illegal option
    exit 0
    ;;
  esac
done