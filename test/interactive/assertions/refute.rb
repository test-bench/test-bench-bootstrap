require_relative '../automated_init'

context "Refute" do
  context "Pass" do
    test "False" do
      refute(false)
    end

    test "Nil" do
      refute(nil)
    end
  end

  test "Failure" do
    begin
      refute(true)
    rescue TestBench::Bootstrap::AssertionFailure => assertion_failure
    end

    assert(!assertion_failure.nil?)
  end
end
