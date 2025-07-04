module TestBenchBootstrap
  module TestBench
    class Run
      module Controls
        module Summary
          def self.example
            Unstyled.example
          end

          module Unstyled
            def self.example
              <<~TEXT
              #{File::Unstyled.example}
              #{Run::Unstyled.example}
              TEXT
            end
          end

          module Styled
            def self.example
              <<~TEXT
              #{File::Styled.example}\e[m
              #{Run::Styled.example}\e[m
              TEXT
            end
          end

          module Initial
            def self.unstyled
              <<~TEXT
              #{Run::Initial.unstyled}
              TEXT
            end

            def self.styled
              <<~TEXT
              #{Run::Initial.styled}\e[m
              TEXT
            end
          end
        end
      end
    end
  end
end
