require_relative './test_init'

paths = ARGV.empty? ? ['test/interactive'] : ARGV

TestBench::Bootstrap::Run.(paths)
