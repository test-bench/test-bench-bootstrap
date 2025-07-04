module TestBenchBootstrap
  module TestBench
    class Executable
      module Defaults
        def self.path
          ENV.fetch('TEST_BENCH_DEFAULT_TEST_PATH', 'test/automated')
        end

        def self.program_name
          $PROGRAM_NAME || 'bench'
        end
      end
    end
  end
end
