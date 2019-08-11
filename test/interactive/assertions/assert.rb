require_relative '../interactive_init'

context "Assert" do
  test "Pass" do
    assert(true)
  end

  test "Failure" do
    begin
      assert(false)
    rescue TestBench::Bootstrap::AssertionFailure => assertion_failure
    end

    assert(!assertion_failure.nil?)
  end
end
