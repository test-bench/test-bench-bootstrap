require_relative './automated_init'

context "Test" do
  test "Pass" do
    #
  end

  test "Skip"

  context "Fail" do
    begin
      test "Assertion failure" do
        assert(false)
      end

      fail

    rescue TestBench::Bootstrap::Failure
      comment "(Above failure is expected)"
    end

    begin
      test "Error" do
        fail
      end

      fail

    rescue TestBench::Bootstrap::Failure
      comment "(Above failure is expected)"
    end
  end

  context "Prose Argument Omitted" do
    test do
      assert(true)
    end

    test

    begin
      test do
        assert(false)
      end

      fail

    rescue TestBench::Bootstrap::Failure
      comment "(Above failure is expected)"
    end
  end
end
