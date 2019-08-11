ENV['TEST_BENCH_TESTS_DIR'] ||= 'test/interactive'

require_relative './test_init'

TestBench::Bootstrap::Run.()
