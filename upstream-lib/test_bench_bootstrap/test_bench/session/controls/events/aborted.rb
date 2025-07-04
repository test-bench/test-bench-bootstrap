module TestBenchBootstrap
  module TestBench
    class Session
      module Controls
        module Events
          module Aborted
            def self.example(message: nil, location: nil)
              message ||= self.message
              location ||= self.location

              aborted = Session::Events::Aborted.new

              aborted.message = message
              aborted.location = location

              aborted.metadata = Metadata.example

              aborted
            end

            def self.message
              Exception::Message.example
            end

            def self.location
              Backtrace::Location.example
            end

            def self.other_example
              Other.example
            end

            module Other
              def self.example
                Aborted.example(message:, location:)
              end

              def self.message
                Message::Error.other_example
              end

              def self.location
                Backtrace::Location.other_example
              end
            end
          end
        end
      end
    end
  end
end
