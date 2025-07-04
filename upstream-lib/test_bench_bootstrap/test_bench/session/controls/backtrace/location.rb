module TestBenchBootstrap
  module TestBench
    class Session
      module Controls
        module Backtrace
          module Location
            def self.example(index=nil, backtrace: nil)
              index ||= 0
              backtrace ||= self.backtrace

              file, line_number, _ = backtrace[index].split(':', 3)

              "#{file}:#{line_number}"
            end

            def self.backtrace
              Exception::Example.backtrace
            end

            def self.other_example
              example(1)
            end

            module AbsolutePath
              def self.example(index=nil)
                Location.example(index, backtrace:)
              end

              def self.backtrace
                Exception::AbsolutePaths::Example.backtrace
              end

              module Local
                def self.example(index=nil)
                  Location.example(index, backtrace:)
                end

                def self.backtrace
                  Backtrace::AbsolutePaths::Local.backtrace
                end
              end
            end
          end
        end
      end
    end
  end
end
