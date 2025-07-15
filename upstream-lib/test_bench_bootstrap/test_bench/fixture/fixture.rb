module TestBenchBootstrap
  module TestBench
    module Fixture
      def test_session
        @test_session ||= Session::Substitute.build
      end
      attr_writer :test_session

      def self.assure_boolean(value, message_subject)
        if not value == true || value == false
          raise Session::Failure, "#{message_subject} given non-boolean value: #{value.inspect}"
        end

        return "#{message_subject} failed"
      end

      def assert(value)
        failure_message = Fixture.assure_boolean(value, "Assertion")

        test_session.assert(value, failure_message)
      end

      def refute(value)
        failure_message = Fixture.assure_boolean(value, "Refutation")

        negated_value = !value

        test_session.assert(negated_value, failure_message)
      end

      def assert_raises(exception_class=nil, message=nil, strict: nil, &block)
        if exception_class.nil?
          strict = false
          exception_class = StandardError
        end

        if strict.nil?
          strict = true
        end

        test_session.detail "Expected exception: #{exception_class}#{' (strict)' if strict}"
        if not message.nil?
          test_session.detail "Expected message: #{message.inspect}"
        end

        block.()

      rescue exception_class => exception
        test_session.detail "Raised exception: #{exception.inspect}#{" (subclass of #{exception_class})" if exception.class < exception_class}"

        if strict && !exception.instance_of?(exception_class)
          raise
        end

        if not message.nil?
          assert(exception.message == message)
        else
          assert(true)
        end

      else
        test_session.detail "(No exception was raised)"
        assert(false)
      end

      def refute_raises(exception_class=nil, strict: nil, &block)
        if exception_class.nil?
          strict = false
          exception_class = StandardError
        end

        if strict.nil?
          strict = true
        end

        test_session.detail "Prohibited exception: #{exception_class}#{' (strict)' if strict}"

        block.()

      rescue exception_class => exception

        test_session.detail "Raised exception: #{exception.inspect}#{" (subclass of #{exception_class})" if exception.class < exception_class}"

        if strict && !exception.instance_of?(exception_class)
          raise
        end

        assert(false)

      else
        test_session.detail "(No exception was raised)"
        assert(true)
      end

      def self.comment_text_and_disposition(text_or_fixture, style: nil, disposition: nil)
        case text_or_fixture
        in String => text
          style ||= Output::CommentStyle.detect

        in Fixture => fixture
          style ||= Output::CommentStyle.block

          test_session = fixture.test_session

          text = Output::Get.(test_session)

        in Object => object
          style ||= Output::CommentStyle.detect

          text = String.try_convert(object)
          if text.nil?
            raise TypeError, "no implicit conversion of #{object.class} into String"
          end
        end

        disposition ||= Output::CommentStyle.get_disposition(style)

        return text, disposition
      end

      ## Remove when no longer in use - Nathan, Tue Jul 15 2025
      def self.output(fixture)
        test_session = fixture.test_session

        Output::Get.(test_session)
      end

      def comment(heading_text=nil, text_or_fixture, style: nil, disposition: nil)
        if not heading_text.nil?
          heading_style = Output::CommentStyle.heading

          comment(heading_text, style: heading_style)
        end

        text, disposition = Fixture.comment_text_and_disposition(text_or_fixture, style:, disposition:)

        test_session.comment(text, disposition)
      end

      def detail(heading_text=nil, text_or_fixture, style: nil, disposition: nil)
        if not heading_text.nil?
          heading_style = Output::CommentStyle.heading

          detail(heading_text, style: heading_style)
        end

        text, disposition = Fixture.comment_text_and_disposition(text_or_fixture, style:, disposition:)

        test_session.detail(text, disposition)
      end

      def self.title(title)
        if title.nil? || title.instance_of?(String)
          return title
        end

        title_string = String.try_convert(title)
        if title_string.nil?
          raise TypeError, "can't convert #{title.class} into #{String}"
        end

        title_string
      end

      def test(title=nil, &block)
        title = Fixture.title(title)

        if block.nil?
          skip_message = title
          test_session.skip(skip_message)
          return nil
        end

        result = test_session.test(title, &block)

        Session::Result.resolve(result, strict: true)
      end

      def test!(...)
        if not test(...)
          throw(Session::ExecutionBreak)
        end
      end

      def context(title=nil, &block)
        title = Fixture.title(title)

        if block.nil?
          skip_message = title
          test_session.skip(skip_message)
          return nil
        end

        result = test_session.context(title, &block)

        Session::Result.resolve(result, strict: true)
      end

      def context!(...)
        if not context(...)
          throw(Session::ExecutionBreak)
        end
      end

      def fixture(fixture_class, *, test_session: nil, **, &)
        test_session ||= self.test_session

        fixture = Build.(fixture_class, *, test_session:, **, &)

        fixture.()

        fixture
      end
    end
  end
end
