require_relative '../automated_init'

context "Assert Raises" do
  context "Optional Error Class Omitted" do
    test "Pass" do
      assert_raises do
        fail
      end
    end

    test "Failure" do
      assert_raises do
        #
      end

      fail

    rescue TestBench::Bootstrap::AssertionFailure
    end
  end

  context "Optional Error Class Given" do
    test "Pass" do
      assert_raises KeyError do
        {}.fetch(:some_key)
      end
    end

    context "Failure" do
      test "No error raised" do
        assert_raises do
          #
        end

        fail

      rescue TestBench::Bootstrap::AssertionFailure
      end

      context "Unrelated Error Class Raised" do
        test "Error is not rescued" do
          assert_raises ArgumentError do
            {}.fetch(:some_key)
          end

          fail

        rescue KeyError
        end
      end

      context "Subclass Of Expected Error Class Raised" do
        test "Error is not rescued" do
          assert_raises IndexError do
            {}.fetch(:some_key)
          end

          fail

        rescue KeyError
        end
      end
    end
  end
end
