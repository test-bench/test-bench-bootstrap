module TestBenchBootstrap
  module TestBench
    class Session
      module Exception
        class FormatBacktrace
          def omit_patterns
            @omit_patterns ||= []
          end
          attr_writer :omit_patterns

          def apex_directory
            @apex_directory ||= ::Dir.pwd
          end
          attr_writer :apex_directory

          attr_accessor :styling
          alias :styling? :styling

          def self.build
            instance = new

            omit_patterns = Defaults.omit_patterns
            instance.omit_patterns = omit_patterns

            styling = Defaults.styling
            instance.styling = styling

            instance
          end

          def self.configure(receiver, attr_name: nil)
            attr_name ||= :format_backtrace

            instance = build
            receiver.public_send(:"#{attr_name}=", instance)
          end

          def call(exception)
            backtrace_locations = exception.backtrace_locations

            if backtrace_locations.nil?
              return
            end

            if styling?
              omitted_text = "\e[2;3m*omitted*\e[23;22m"
            else
              omitted_text = '*omitted*'
            end

            backtrace = []

            original_frame = exception.backtrace_locations.first.to_s
            backtrace << original_frame

            omitting = false

            exception.backtrace_locations[1..-1].each do |backtrace_location|
              if omit?(backtrace_location)
                if not omitting
                  backtrace << omitted_text
                end

                omitting = true
              else
                omitting = false
              end

              if not omitting
                backtrace << backtrace_location.to_s
              end
            end

            backtrace.each do |backtrace_location_text|
              delete_apex_directory_prefix(backtrace_location_text)
            end

            exception.set_backtrace(backtrace)

            if exception.cause
              self.(exception.cause)
            end

            location = exception.backtrace_locations.find do |backtrace_location|
              !omit?(backtrace_location)
            end

            location ||= exception.backtrace_locations.first

            location = "#{location.path}:#{location.lineno}"
            delete_apex_directory_prefix(location)
            location
          end

          def omit?(backtrace_location)
            backtrace_path = backtrace_location.path

            omit_patterns.any? do |omit_pattern|
              ::File.fnmatch?(omit_pattern, backtrace_path, ::File::FNM_EXTGLOB)
            end
          end

          def delete_apex_directory_prefix(backtrace_location_text)
            if styling?
              relative_path_prefix = "\e[2m./\e[22m"
            else
              relative_path_prefix = './'
            end

            apex_directory_prefix = ::File.join(apex_directory, '')

            if backtrace_location_text.delete_prefix!(apex_directory_prefix)
              backtrace_location_text.insert(0, relative_path_prefix)
            end
          end

          module Defaults
            def self.omit_patterns
              env_omit_backtrace_pattern = ENV.fetch('TEST_BENCH_OMIT_BACKTRACE_PATTERN', '')

              env_omit_backtrace_pattern.split(':')
            end

            def self.styling
              ::Exception.to_tty?
            end
          end
        end
      end
    end
  end
end
