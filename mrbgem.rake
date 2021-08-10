MRuby::Gem::Specification.new('mruby-test-bench-bootstrap') do |spec|
  spec.licenses = ["MIT"]
  spec.authors = ["Nathan Ladd"]

  spec.summary = "A minimal test framework for testing TestBench"
  spec.homepage = 'https://github.com/test-bench/test-bench-bootstrap'

  spec.search_package 'glib-2.0'

  spec.rbfiles << File.join(spec.dir, 'lib/test_bench/bootstrap.rb')
  spec.bins << 'bench-bootstrap'

  spec.add_dependency 'mruby-require', :github => 'esc-rb/mruby-require', :branch => 'main'
end
