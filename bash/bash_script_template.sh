#!/usr/bin/env bash

# This is a bash script template inspired by the following sources:
# https://betterdev.blog/minimal-safe-bash-script-template/
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46
set -Eeuo pipefail

# Try to get the script dir
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Try to clean up on SIGINT, SIGTERM, ERR, or EXIT
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # TODO: script cleanup here
  msg "${GREEN}Cleaning up...${NOFORMAT}"
}

# Print out the usage
usage() {
  # TODO: Script description here.
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] arg1 [arg2...]

...
EOF
  exit
}

# Nice colors
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

# msg is meant to be used to print everything that is not a script output.
msg() {
  echo >&2 -e "${1-}"
}

# Fancy exit
die() {
  local goodbye=$1
  local code=${2-1} # default exit status 1
  msg "${goodbye}"
  exit "${code}"
}

parse_params() {
  # default values of variables set from params
  # TODO: choose your parameters
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) flag=1 ;; # example flag
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  # TODO: 
  [[ -z "${param-}" ]] && die "Missing required parameter: param"
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

# Setup
parse_params "$@"
setup_colors

# TODO: Add script logic here
msg "${GREEN}Read parameters:${NOFORMAT}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"
 
die "${GREEN}Done.${NOFORMAT}" 0

