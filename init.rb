if RUBY_ENGINE != 'mruby'
  lib_dir = "#{__dir__}/lib"
  $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

  require 'test_bench/bootstrap'
end
