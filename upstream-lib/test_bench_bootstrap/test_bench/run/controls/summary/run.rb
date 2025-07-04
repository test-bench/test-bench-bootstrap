module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Summary
          module Run
            def self.example
              Unstyled.example
            end

            module Unstyled
              def self.example
                <<~TEXT
                Attempted 222 files: 200 completed, 20 aborted, 2 not found
                1111 tests in 0.00 seconds (Inf tests/sec)
                1000 passed, 111 failed, 11+ skipped
                TEXT
              end
            end

            module Styled
              def self.example
                <<~TEXT
                Attempted 222 files: 200 completed, \e[1;31m20 aborted\e[39;22m, \e[31m2 not found\e[m
                1111 tests in 0.00 seconds (Inf tests/sec)\e[m
                \e[32m1000 passed\e[39m, \e[1;31m111 failed\e[39;22m, \e[33m11+ skipped\e[m
                TEXT
              end
            end

            module Initial
              def self.unstyled
                <<~TEXT
                Attempted 0 files: 0 completed, 0 aborted, 0 not found
                0 tests in 0.00 seconds (NaN tests/sec)
                0 passed, 0 failed, 0 skipped
                TEXT
              end

              def self.styled
                <<~TEXT
                Attempted 0 files: 0 completed, 0 aborted, 0 not found\e[m
                0 tests in 0.00 seconds (NaN tests/sec)\e[m
                \e[2;3m0 passed\e[23;22m, 0 failed, 0 skipped\e[m
                TEXT
              end
            end
          end
        end
      end
    end
  end
end
