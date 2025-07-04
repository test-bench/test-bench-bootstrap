module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Summary
          module File
            module Totals
              def self.example(attempted: nil, completed: nil, aborted: nil, not_found: nil)
                attempted ||= self.attempted
                completed ||= self.completed
                aborted ||= self.aborted
                not_found ||= self.not_found

                TestBench::Run::Summary::FileTotals.new(attempted, completed, aborted, not_found)
              end

              def self.attempted
                222
              end

              def self.completed
                200
              end

              def self.aborted
                20
              end

              def self.not_found
                2
              end
            end
          end
        end
      end
    end
  end
end
