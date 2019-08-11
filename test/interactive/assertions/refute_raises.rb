require_relative '../automated_init'

context "Refute Raises" do
  test "Pass" do
    refute_raises KeyError do
      #
    end
  end

  context "Failure" do
    test "Error raised" do
      refute_raises KeyError do
        {}.fetch(:some_key)
      end

      fail

    rescue TestBench::Bootstrap::AssertionFailure
    end

    context "Unrelated Error Class Raised" do
      test "Error is not rescued" do
        refute_raises ArgumentError do
          {}.fetch(:some_key)
        end

        fail

      rescue KeyError
      end
    end

    context "Subclass Of Expected Error Class Raised" do
      test "Error is not rescued" do
        refute_raises IndexError do
          {}.fetch(:some_key)
        end

        fail

      rescue KeyError
      end
    end
  end
end
