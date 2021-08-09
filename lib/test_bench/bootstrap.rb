module TestBench
  module Bootstrap
    def self.activate
      Object.include(Fixture)
    end

    if RUBY_ENGINE != 'mruby'
      class Abort < SystemExit
        def self.build
          new(1)
        end
      end
    end

    class Abort
      def self.call
        Output.raw_write("#{Bootstrap} is aborting\n")
        instance = build
        raise instance
      end
    end

    module Backtrace
      if RUBY_ENGINE != 'mruby'
        def self.frame(frame_index)
          frame_index += 1

          caller[frame_index]
        end
      end
    end

    class AssertionFailure < RuntimeError
      def self.build(frame_index=nil)
        frame_index ||= 0

        frame = Backtrace.frame(frame_index)

        instance = new
        instance.set_backtrace([frame])
        instance
      end

      def message
        "Assertion failed"
      end
    end

    module Path
      if RUBY_ENGINE != 'mruby'
        def self.match?(pattern, string)
          ::File.fnmatch?(pattern, string)
        end

        def self.search(path, include_pattern=nil, exclude_pattern=nil)
          files = []

          if ::File.directory?(path)
            search_directory(path, files, include_pattern, exclude_pattern)
          elsif ::File.exist?(path)
            files << path
          else
            raise LoadError, "no such file or directory -- #{path}"
          end

          files
        end

        def self.search_directory(dir, files, include_pattern=nil, exclude_pattern=nil)
          include_pattern ||= '*.rb'

          ::Dir[::File.join(dir, '**', '*')].each do |path|
            next if ::File.directory?(path)

            if match?(include_pattern, path)
              if exclude_pattern.nil? || !match?(exclude_pattern, path)
                files << path
              end
            end
          end
        end
      end
    end

    module Fixture
      def assert(value)
        unless value
          raise AssertionFailure.build(1)
        end
      end

      def assert_raises(error_class=nil, &block)
        begin
          Output.raw_write("assert_raises\n")
          block.()

        rescue (error_class || StandardError) => error
          return if error_class.nil?

          if error.instance_of?(error_class)
            return
          else
            raise error
          end
        end

        raise AssertionFailure.build(1)
      end

      def refute(value)
        if value
          raise AssertionFailure.build(1)
        end
      end

      def refute_raises(error_class=nil, &block)
        block.()

      rescue (error_class || StandardError) => error
        unless error.instance_of?(error_class)
          raise error
        end

        raise AssertionFailure.build(1)
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
          Output.error(error)

          Abort.()
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
            Output.error(error)
          end

          Abort.()
        end
      end

      def _test(prose=nil, &block)
        test(prose)
      end

      def comment(text)
        Output.write(text)
      end

      def detail(text)
        comment(text)
      end

      def fixture(cls, *args, **kwargs, &block)
        fixture = TestBench::Fixture.(cls, *args, **kwargs, &block)

        passed = !fixture.test_session.failed?

        assert(passed)
      end
    end

    module Output
      extend self

      def write(text, device: nil, sgr_code: nil, sgr_codes: nil, tab_indent: nil)
        indent(text, device: device, sgr_code: sgr_code, sgr_codes: sgr_codes, tab_indent: tab_indent)
      end

      def error(error)
        omit_backtrace_pattern = Defaults.omit_backtrace_pattern

        omitting = false

        write("\e[1mTraceback\e[22m (most recent call last):", sgr_code: 0x31)

        rjust_length = error.backtrace.length.to_s.length

        reverse_backtrace = error.backtrace[1..-1].reverse

        reverse_backtrace.each_with_index do |frame, index|
          frame = frame.dup
          frame.chomp!

          previous_frame = frame

          file, _ = frame.split(':', 2)

          line = ' ' * rjust_length

          index_text = index.to_s
          index_range = (-index_text.length..-1)

          if Path.match?(omit_backtrace_pattern, file)
            if omitting
              next
            else
              omitting = true

              line[index_range] = '?' * index_text.length
              line += ": *omitted*"

              write(line, sgr_codes: [0x2, 0x3, 0x31], tab_indent: true)
            end
          else
            omitting = false

            line[index_range] = index_text
            line += ": #{frame}"

            write(line, sgr_code: 0x31, tab_indent: true)
          end
        end

        if error.message.empty?
          if error.instance_of?(RuntimeError)
            write("#{error.backtrace[0]}: \e[1;4munhandled exception\e[24;22m", sgr_code: 0x31)
            return
          end

          error.message = error.class
        end

        write("#{error.backtrace[0]}: \e[1m#{error} (\e[4m#{error.class}\e[24m)\e[22m", sgr_code: 0x31)
      end

      def newline
        write('')
      end

      def indent(text, device: nil, sgr_code: nil, sgr_codes: nil, tab_indent: nil, &block)
        unless text.nil?
          sgr_codes ||= []
          unless sgr_code.nil?
            sgr_codes << sgr_code
          end

          unless sgr_codes.empty?
            sgr_codes.map! do |sgr_code|
              sgr_code.to_s(16)
            end

            text = "\e[#{sgr_codes.join(';')}m#{text}\e[0m"
          end

          text = "#{"\t" if tab_indent}#{'  ' * indentation}#{text}\n"

          raw_write(text, device)
        end

        return if block.nil?

        self.indentation += 1 unless text.nil?

        begin
          block.()
        ensure
          self.indentation -= 1 unless text.nil?
        end
      end

      def raw_write(text, device=nil)
        device ||= self.device

        device.write(text)
      end

      def indentation
        @indentation ||= 0
      end
      attr_writer :indentation

      def device
        @device ||= Defaults.output_device
      end
    end

    module Run
      def self.call(paths=nil, exclude_pattern: nil)
        paths ||= []
        exclude_pattern ||= Defaults.exclude_file_pattern

        if paths.is_a?(String)
          paths = [paths]
        end

        if paths.empty?
          paths << Defaults.tests_dir
        end

        paths.each do |path|
          Path.search(path, '*.rb', exclude_pattern).each do |file|
            Output.write "Running #{file}"

            begin
              load(file)
            ensure
              Output.newline
            end
          end
        end
      end
    end

    module Defaults
      def self.get(env_var, default)
        if env.key?(env_var)
          env[env_var]
        else
          default
        end
      end

      def self.exclude_file_pattern
        get('TEST_BENCH_EXCLUDE_FILE_PATTERN', '*_init.rb')
      end

      def self.omit_backtrace_pattern
        get('TEST_BENCH_OMIT_BACKTRACE_PATTERN', '*/test_bench/bootstrap.rb')
      end

      def self.tests_dir
        get('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
      end

      if RUBY_ENGINE == 'mruby'
        def self.env
          {}
        end
      else
        def self.output_device
          $stdout
        end

        def self.env
          ::ENV
        end
      end
    end
  end
end
