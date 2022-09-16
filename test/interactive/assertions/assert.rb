require_relative '../interactive_init'

context "Assert" do
  test "Pass" do
    assert(true)
  end

  test "Failure" do
    assert(false)
  end

rescue TestBench::Bootstrap::AssertionFailure
  comment "(Above failure is expected)"
end
