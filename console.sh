#!/usr/bin/env sh

set -eu

irb \
  -I lib/ \
  -r test_bench/bootstrap \
  --readline \
  --prompt simple \
  $@
