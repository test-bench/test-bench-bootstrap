require_relative './interactive_init'

context "Comment" do
  comment "Some comment"
  detail "Some detail"

  test do
    assert(true)
  end
end
