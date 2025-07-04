module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Status
          def self.example(tests: nil, failures: nil, errors: nil, skipped: nil)
            tests ||= self.tests
            failures ||= self.failures
            errors ||= self.errors
            skipped ||= self.skipped

            test_sequence = tests
            failure_sequence = failures
            error_sequence = errors
            skip_sequence = skipped

            TestBench::Session::Status.new(
              test_sequence,
              failure_sequence,
              error_sequence,
              skip_sequence
            )
          end

          def self.tests
            1_111
          end

          def self.failures
            111
          end

          def self.errors
            0
          end

          def self.skipped
            11
          end
        end
      end
    end
  end
end
