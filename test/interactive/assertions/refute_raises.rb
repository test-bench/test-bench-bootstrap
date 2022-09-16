require_relative '../interactive_init'

context "Refute Raises" do
  test "Pass" do
    refute_raises(NameError) do
      Object
    end
  end

  context "Failure" do
    context do
      test "Error raised" do
        refute_raises(NameError) do
          SomeUnknownConstant
        end
      end

    rescue TestBench::Bootstrap::AssertionFailure
      comment "(Above failure is expected)"
    end

    context "Unrelated Error Class Raised" do
      test "Error is not rescued" do
        refute_raises(ArgumentError) do
          SomeUnknownConstant
        end
      end

    rescue NameError
      comment "(Above failure is expected)"
    end

    context "Subclass Of Expected Error Class Raised" do
      cls = Class.new(NameError)

      test "Error is not rescued" do
        refute_raises(NameError) do
          raise cls, "Example subclass error"
        end
      end

    rescue cls
      comment "(Above failure is expected)"
    end
  end
end
