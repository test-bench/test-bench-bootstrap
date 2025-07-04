module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Summary
          module File
            module Unstyled
              def self.example
                <<~TEXT
                File Summary
                - - -
                - #{Path::File.example}: no tests, 11 failures, 12+ skipped, 2 errors:
                  #{Message::Error.example}
                  #{Session::BacktraceLocation.example}

                  #{Message::Error.other_example}
                  #{Session::BacktraceLocation.other_example}

                - #{Path::File.other_example}: 1 failure
                TEXT
              end
            end

            module Styled
              def self.example
                <<~TEXT
                \e[1;4m\e[31mFile Summary\e[m
                \e[31m\e[2m-\e[22m \e[1m#{Info.path}\e[22m: no tests, 11 failures, 12+ skipped, 2 errors:\e[m
                  \e[31m#{Message::Error.example}\e[m
                  \e[31m#{Session::BacktraceLocation.example}\e[m
                \e[m
                  \e[31m#{Message::Error.other_example}\e[m
                  \e[31m#{Session::BacktraceLocation.other_example}\e[m
                \e[m
                \e[31m\e[2m-\e[22m \e[1m#{Info::Other.path}\e[22m: 1 failure\e[m
                TEXT
              end
            end
          end
        end
      end
    end
  end
end
