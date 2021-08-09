require_relative '../interactive_init'

context "Assert Raises" do
  context "Optional Error Class Omitted" do
    test "Pass" do
      assert_raises do
        raise "Some error"
      end
    end

    test "Failure" do
      assert_raises do
        #
      end
    end

  rescue TestBench::Bootstrap::Abort
    comment "(Above failure is expected)"
  end

  context "Optional Error Class Given" do
    test "Pass" do
      assert_raises(NameError) do
        SomeUnknownConstant
      end
    end

    context "Failure" do
      context do
        test "No error raised" do
          assert_raises(NameError) do
            #
          end
        end

      rescue TestBench::Bootstrap::Abort
        comment "(Above failure is expected)"
      end

      context "Unrelated Error Class Raised" do
        test do
          assert_raises(ArgumentError) do
            SomeUnknownConstant
          end
        end

      rescue TestBench::Bootstrap::Abort
        comment "(Above failure is expected)"
      end

      context "Subclass Of Expected Error Class Raised" do
        cls = Class.new(NameError)

        test "Error is not rescued" do
          assert_raises(NameError) do
            raise cls, "Example subclass error"
          end
        end

      rescue TestBench::Bootstrap::Abort
        comment "(Above failure is expected)"
      end
    end
  end
end
