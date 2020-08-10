MRuby::Gem::Specification.new('mruby-test-bench-bootstrap') do |spec|
  spec.authors = ["Nathan Ladd"]
  spec.homepage = "https://github.com/test-bench/test-bench-bootstrap"
  spec.licenses = ["MIT"]
  spec.summary = "A minimal test framework for testing TestBench"

  spec.rbfiles = [File.join(__dir__, 'lib/test_bench/bootstrap.rb')]

  spec.mrblib_dir = 'lib'

  spec.add_dependency 'mruby-enumerator'
  spec.add_dependency 'mruby-array-ext'
  spec.add_dependency 'mruby-hash-ext'
  spec.add_dependency 'mruby-kernel-ext'
  spec.add_dependency 'mruby-object-ext'
  spec.add_dependency 'mruby-io'

  spec.add_dependency 'mruby-env', :mgem => 'mruby-env'
  spec.add_dependency 'mruby-onig-regexp', :mgem => 'mruby-onig-regexp'
  spec.add_dependency 'mruby-dir', :mgem => 'mruby-dir'
  spec.add_dependency 'mruby-dir-glob', :mgem => 'mruby-dir-glob'

  spec.add_dependency 'mruby-exception-cause', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/exception-cause'
  spec.add_dependency 'mruby-require', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/require'
  spec.add_dependency 'mruby-system-exit', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/system-exit'
  spec.add_dependency 'mruby-toplevel-binding-receiver', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/toplevel-binding-receiver'
end
