module TestBenchBootstrap
  module TestBench
    class Executable
      module Controls
        module StandardInput
          module Create
            def self.call(*paths)
              if paths.empty?
                paths = Path.examples
              end

              content = <<~TEXT
              #{paths.join("\n")}
              TEXT

              file = Session::Controls::Path::File::Create.(content)

              ::File.open(file, 'r')
            end

            def self.contents
              <<~TEXT
              #{Path.example}
              TEXT
            end
          end
        end
      end
    end
  end
end
