#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#
# bundle add github-pages jekyll-avatar jekyll-mentions --group "jekyll_plugins"
# bundle add jekyll webrick faraday-retry --group "development"
#
#====================================================

# shellcheck disable=SC1091
. ".bash/incl/all.sh"

_jvcl_::gem_update() {
  local _gem _gems=("bundler")
  for _gem in "${_gems[@]}"; do
    _jvcl_::h1 "Checking if ${_gem} is installed..."
    gem info "${_gem}" || gem install "${_gem}"
    gem update "${_gem}"
  done
}

_jvcl_::bundle_update() {
  local _opt
  for _opt in "check" "doctor" "install" "update" "lock"; do
    bundle "${_opt}" --verbose
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

# End sourced section
# What is the bash equivalent to Python's `if __name__ == '__main__'`?
# <https://stackoverflow.com/a/46004518/2477854>
return 2>/dev/null

# shellcheck disable=SC2317
if _jvcl_::brew_install_formula "ruby"; then
  _jvcl_::build_gem
fi