module TestBenchBootstrap
  module TestBench
    class Session
      module Controls
        module Backtrace
          def self.example
            [
              Exception::Example.backtrace.first,
              "*omitted*",
              Exception::Example.backtrace.last
            ]
          end

          def self.pattern
            Pattern.example
          end

          def self.location
            Location.example
          end

          module Pattern
            def self.example
              '*/some-subdir/*'
            end

            def self.other_example
              '*/some-other-subdir/*'
            end
          end

          module Styling
            def self.example
              backtrace = AbsolutePaths::Local::Backtrace.example(styling: true)

              [
                backtrace.first,
                "\e[2;3m*omitted*\e[23;22m",
                backtrace.last
              ]
            end
          end

          module Cause
            def self.example
              [
                Exception::Cause::Example.backtrace.first,
                "*omitted*",
                Exception::Cause::Example.backtrace.last
              ]
            end
          end

          module AbsolutePaths
            def self.example
              Exception::AbsolutePaths::Example.backtrace
            end

            module Local
              def self.example
                backtrace = self.backtrace

                [
                  backtrace.first,
                  "*omitted*",
                  backtrace.last
                ]
              end

              def self.backtrace
                Backtrace.example
              end

              def self.apex_directory
                Backtrace.apex_directory
              end

              module Backtrace
                def self.example(styling: nil)
                  styling ||= false

                  if styling
                    relative_path_prefix = "\e[2m./\e[22m"
                  else
                    relative_path_prefix = "./"
                  end

                  Exception::AbsolutePaths::Example.backtrace_locations.map do |backtrace_location|
                    backtrace_location_text = backtrace_location.to_s

                    backtrace_location_text.delete_prefix!(::File.join(apex_directory, ''))

                    backtrace_location_text.insert(0, relative_path_prefix)

                    backtrace_location_text
                  end
                end

                def self.apex_directory
                  Path::ApexDirectory.tmpdir
                end
              end
            end
          end
        end
      end
    end
  end
end
