module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Summary
          module File
            module Info
              def self.example(path: nil, tests: nil, failures: nil, skipped: nil, aborted_events: nil)
                path ||= self.path
                tests ||= self.tests
                failures ||= self.failures
                skipped ||= self.skipped
                aborted_events ||= self.aborted_events

                session_status = Status.example(
                  tests:,
                  failures:,
                  skipped:,
                  errors: aborted_events.count
                )

                TestBench::Run::Summary::FileInfo.new(path, session_status, aborted_events)
              end

              def self.path
                Path::File.example
              end

              def self.tests
                0
              end

              def self.failures
                11
              end

              def self.skipped
                12
              end

              def self.aborted_events
                [
                  Session::Events::Aborted.example,
                  Session::Events::Aborted.other_example
                ]
              end

              def self.other_example
                Other.example
              end

              module Other
                def self.example(tests: nil, failures: nil, skipped: nil, aborted_events: nil)
                  tests ||= self.tests
                  failures ||= self.failures
                  skipped ||= self.skipped
                  aborted_events ||= self.aborted_events

                  Info.example(path:, tests:, failures:, skipped:, aborted_events:)
                end

                def self.path
                  Path::File.other_example
                end

                def self.tests
                  1
                end

                def self.failures
                  1
                end

                def self.skipped
                  0
                end

                def self.aborted_events
                  []
                end
              end

              module NotFound
                def self.example
                  TestBench::Run::Summary::FileInfo.not_found(path)
                end

                def self.path
                  "/some-not-found-file.rb"
                end
              end

              module Set
                def self.call(summary)
                  file_info = File::Info.example
                  other_file_info = File::Info.other_example

                  summary.add_file(file_info)
                  summary.add_file(other_file_info)
                end
              end
            end
          end
        end
      end
    end
  end
end
