module TestBenchBootstrap
  module TestBench
    module Random
      module Defaults
        def self.seed
          ENV.fetch('TEST_BENCH_SEED') do
            @seed ||= ::Random.new_seed.to_s(36)
          end
        end
      end
    end
  end
end
