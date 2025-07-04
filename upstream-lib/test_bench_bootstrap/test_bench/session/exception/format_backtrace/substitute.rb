module TestBenchBootstrap
  module TestBench
    class Session
      module Exception
        class FormatBacktrace
          module Substitute
            def self.build
              FormatBacktrace.new
            end

            class FormatBacktrace
              attr_accessor :location
              alias :set_location :location=

              def exceptions
                @exceptions ||= []
              end

              def call(exception)
                exceptions << exception

                location
              end

              def formatted?(exception)
                exceptions.include?(exception)
              end
            end
          end
        end
      end
    end
  end
end
