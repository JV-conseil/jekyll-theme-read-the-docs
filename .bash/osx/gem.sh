#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2024 JV-conseil
#                 All rights reserved
#
# bundle add github-pages jekyll-avatar jekyll-mentions --group "jekyll_plugins"
# bundle add jekyll webrick faraday-retry --group "development"
#
#====================================================

# shellcheck source=/dev/null
. ".bash/incl/all.sh"

_jvcl_::gem_update() {
  local _gem _gems=("bundler")
  # gem update --system
  for _gem in "${_gems[@]}"; do
    _jvcl_::h1 "Checking if ${_gem} is installed..."
    gem info "${_gem}" || gem install "${_gem}"
    gem update "${_gem}" || printf "Oops command failed: bundle %s --verbose" "${_gem}"
  done
  gem update --system || printf "Oops command failed: gem update --system"
}

_jvcl_::bundle_update() {
  local -a _cmd
  local _opt

  rm -vrf "./Gemfile.lock" || printf "ERROR - _jvcl_::bundle_update - command failed: rm -vrf ./Gemfile.lock"

  for _opt in "check" "doctor" "install" "update" "lock"; do
    _cmd=(bundle "${_opt}" --verbose)
    [[ "${_opt}" == "update" ]] && _cmd+=(--all)
    # IFS=' ' printf "DEBUG - _jvcl_::bundle_update - %s\n" "${_cmd[*]}"
    "${_cmd[@]}" ||
      printf "ERROR - _jvcl_::bundle_update - bundle %s --verbose\n" "${_opt}"
  done
}

_jvcl_::build_gem() {
  local _pkg
  if _pkg="$(cat <'package.json' | jq -r '.name')"; then
    gem uninstall "${_pkg}"
    gem build ./*.gemspec
    gem install ./*.gem && rm -f ./*.gem
  fi
}

# Bash equivalent of Python if __name__ == "__main__":
# <https://stackoverflow.com/a/70662116/2477854>
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  if _jvcl_::brew_install_formula "ruby"; then
    _jvcl_::build_gem
  fi
fi
