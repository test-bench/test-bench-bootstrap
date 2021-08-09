require_relative './interactive_init'

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

    rescue TestBench::Bootstrap::Abort
      comment "(Above failure is expected)"
    end

    begin
      test "Error" do
        raise "Some error"
      end

    rescue TestBench::Bootstrap::Abort
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

    rescue TestBench::Bootstrap::Abort
      comment "(Above failure is expected)"
    end
  end
end
