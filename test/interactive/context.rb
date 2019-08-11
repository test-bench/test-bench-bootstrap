require_relative './automated_init'

context "Context" do
  context "Pass" do
    comment "Some comment"
  end

  context "Skip"

  context "Fail" do
    begin
      context "Prose Argument Given" do
        assert(false)
      end

      fail

    rescue TestBench::Bootstrap::Failure
      comment "(Above failure is expected)"
    end
  end

  context "Prose Argument Omitted" do
    context do
      comment "Some comment"
    end

    context

    begin
      context do
        assert(false)
      end

      fail

    rescue TestBench::Bootstrap::Failure
      comment "(Above failure is expected)"
    end
  end
end
