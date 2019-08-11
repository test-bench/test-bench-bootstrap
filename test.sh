#!/bin/sh

ruby \
  --disable-gems \
  --enable-frozen-string-literal \
  test/interactive.rb \
  $@
