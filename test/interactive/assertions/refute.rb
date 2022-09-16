require_relative '../interactive_init'

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
    refute(true)
  end

rescue TestBench::Bootstrap::AssertionFailure
  comment "(Above failure is expected)"
end
