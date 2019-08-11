module TestBench
  module Bootstrap
    def self.activate(receiver=nil)
      receiver ||= TOPLEVEL_BINDING.receiver

      receiver.extend(Fixture)
    end

    module Fixture
      def assert(value)
        unless value
          raise AssertionFailure.build(caller.first)
        end
      end

      def assert_raises(error_class=nil, &block)
        begin
          block.()

        rescue (error_class || StandardError) => error
          return if error_class.nil?

          if error.instance_of?(error_class)
            return
          else
            raise error
          end
        end

        raise AssertionFailure.build(caller.first)
      end

      def refute(value)
        if value
          raise AssertionFailure.build(caller.first)
        end
      end

      def refute_raises(error_class=nil, &block)
        block.()

      rescue (error_class || StandardError) => error
        unless error.instance_of?(error_class)
          raise error
        end

        raise AssertionFailure.build(caller.first)
      end

      def context(prose=nil, &block)
        if block.nil?
          Output.write(prose || 'Context', sgr_code: 0x33)
          return
        end

        unless prose.nil?
          Output.indent(prose, sgr_code: 0x32) do
            context(&block)
          end
          return
        end

        begin
          block.()

        rescue => error
          Fixture.print_error(error)

          raise Failure.build
        end
      end

      def _context(prose=nil, &block)
        context(prose)
      end

      def test(prose=nil, &block)
        if block.nil?
          Output.write(prose || 'Test', sgr_code: 0x33)
          return
        end

        begin
          block.()

          Output.indent(prose, sgr_code: 0x32)

        rescue => error
          Output.indent(prose, sgr_codes: [0x1, 0x31]) do
            Fixture.print_error(error)
          end

          raise Failure.build
        end
      end

      def _test(prose=nil, &block)
        test(prose)
      end

      def comment(text)
        Output.write(text)
      end

      def fixture(cls, *args, **kwargs, &block)
        fixture = TestBench::Fixture.(cls, *args, **kwargs, &block)

        passed = !fixture.test_session.failed?

        assert(passed)
      end

      def self.print_error(error)
        omit_backtrace_pattern = ENV['TEST_BENCH_OMIT_BACKTRACE_PATTERN']
        omit_backtrace_pattern ||= %r{test_bench/bootstrap\.rb}

        omitting = false

        Output.write("\e[1mTraceback\e[22m (most recent call last):", sgr_code: 0x31)

        rjust_length = error.backtrace.length.to_s.length

        error.backtrace[1..-1].reverse_each.with_index do |line, index|
          line = line.dup

          line.chomp!

          if omit_backtrace_pattern.match?(line)
            if omitting
              next
            else
              omitting = true

              header = index.to_s.gsub(/./, '?').rjust(rjust_length, ' ')

              Output.write("#{header}: *omitted*", sgr_codes: [0x2, 0x3, 0x31], tab_indent: true)
            end
          else
            omitting = false

            header = index.to_s.rjust(rjust_length, ' ')

            Output.write("#{header}: #{line}", sgr_code: 0x31, tab_indent: true)
          end
        end

        if error.message.empty?
          if error.instance_of?(RuntimeError)
            Output.write("#{error.backtrace[0]}: \e[1;4munhandled exception\e[24;22m", sgr_code: 0x31)
            return
          end

          error.message = error.class
        end

        Output.write("#{error.backtrace[0]} \e[1m#{error} (\e[4m#{error.class}\e[24m)\e[22m", sgr_code: 0x31)
      end
    end

    module Output
      extend self

      def write(text, device: nil, sgr_code: nil, sgr_codes: nil, tab_indent: nil)
        indent(text, device: device, sgr_code: sgr_code, sgr_codes: sgr_codes, tab_indent: tab_indent)
      end

      def indent(text, device: nil, sgr_code: nil, sgr_codes: nil, tab_indent: nil, &block)
        device ||= $stdout

        unless text.nil?
          sgr_codes = Array(sgr_codes)
          unless sgr_code.nil?
            sgr_codes << sgr_code
          end

          unless sgr_codes.empty?
            sgr_codes.map! do |sgr_code|
              sgr_code.to_s(16)
            end

            text = "\e[#{sgr_codes.join(';')}m#{text}\e[0m"
          end

          text = "#{"\t" if tab_indent}#{'  ' * indentation}#{text}"

          device.puts(text)
        end

        return if block.nil?

        self.indentation += 1 unless text.nil?

        begin
          block.()
        ensure
          self.indentation -= 1 unless text.nil?
        end
      end

      def indentation
        @indentation ||= 0
      end
      attr_writer :indentation
    end

    class AssertionFailure < RuntimeError
      def self.build(caller_location=nil)
        caller_location ||= caller(0)

        instance = new
        instance.set_backtrace([caller_location])
        instance
      end

      def message
        "Assertion failed"
      end
    end

    class Failure < SystemExit
      def self.build
        new(1, "TestBench::Bootstrap is aborting")
      end
    end

    module Run
      def self.call(argv=nil, exclude_file_pattern: nil)
        argv ||= ::ARGV

        exclude_file_pattern = ENV['TEST_BENCH_EXCLUDE_FILE_PATTERN']
        exclude_file_pattern ||= %r{automated_init\.rb}

        if argv.empty?
          tests_dir = ENV['TEST_BENCH_TESTS_DIR'] || 'test/automated'

          file_patterns = [File.join(tests_dir, '**', '*.rb')]
        else
          file_patterns = argv
        end

        file_patterns.each do |file_pattern|
          if File.directory?(file_pattern)
            file_pattern = File.join(file_pattern, '**/*.rb')
          end

          files = Dir[file_pattern].reject do |file|
            File.basename(file).match?(exclude_file_pattern)
          end

          files.sort.each do |file|
            puts "Running #{file}"

            begin
              load file
            ensure
              puts
            end
          end
        end
      end
    end
  end
end
