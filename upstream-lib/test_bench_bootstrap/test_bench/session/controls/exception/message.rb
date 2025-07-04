module TestBenchBootstrap
  module TestBench
    class Session
      module Controls
        module Exception
          module Message
            def self.example
              exception = Example

              exception.detailed_message
            end

            def self.other_example
              exception = Other::Example

              exception.detailed_message
            end
          end
        end
      end
    end
  end
end
