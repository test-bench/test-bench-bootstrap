# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'test_bench-bootstrap'
  spec.version = '7.0.3'

  spec.summary = "Bootstrap implementation of TestBench for testing TestBench"
  spec.description = <<~TEXT.each_line(chomp: true).map(&:strip).join(' ')
  #{spec.summary}
  TEXT

  spec.homepage = 'http://test-bench.software'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/test-bench-demo/test-bench-bootstrap'

  allowed_push_host = ENV.fetch('RUBYGEMS_PUBLIC_AUTHORITY') { 'https://rubygems.org' }
  spec.metadata['allowed_push_host'] = allowed_push_host

  spec.metadata['namespace'] = 'TestBenchBootstrap'

  spec.license = 'MIT'

  spec.authors = ['Brightworks Digital']
  spec.email = 'development@bright.works'

  spec.require_paths = ['lib', 'upstream-lib']

  spec.files = Dir.glob('{lib,upstream-lib}/**/*')

  spec.bindir = 'executables'
  spec.executables = Dir.glob('executables/*').map { |executable| File.basename(executable) }

  spec.platform = Gem::Platform::RUBY

  spec.add_development_dependency 'import_constants'
  spec.add_development_dependency 'test_bench-random'
  spec.add_development_dependency 'test_bench-telemetry'
  spec.add_development_dependency 'test_bench-session'
  spec.add_development_dependency 'test_bench-output'
  spec.add_development_dependency 'test_bench-fixture'
  spec.add_development_dependency 'test_bench-run'
  spec.add_development_dependency 'test_bench-executable'
  spec.add_development_dependency 'test_bench'
end
