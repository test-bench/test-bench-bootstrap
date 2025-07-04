module TestBenchBootstrap
  module TestBench
    module Random
      class Generator
        module Substitute
          def self.build
            Generator.build
          end

          class Generator < Generator
            def self.build
              new(seed)
            end

            def self.seed
              '0'
            end
          end
        end
      end
    end
  end
end
