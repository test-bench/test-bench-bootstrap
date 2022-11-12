require_relative './interactive_init'

context "Details" do
  context "Comment Format" do
    context "Heading" do
      detail "Some Heading:", "Some text", "Some other text", quote: false, heading: true
    end

    context "No Heading" do
      detail "Some text", "Some other text", quote: false, heading: false
    end

    context "Heading, No Details" do
      detail "Some Heading:", quote: false, heading: true
    end

    context "Heading, Empty String" do
      detail "Some Heading:", '', quote: false, heading: true
    end

    context "No Heading, Empty String" do
      detail '', quote: false, heading: false
    end
  end

  context "Quote Format" do
    context "Heading" do
      detail "Some Heading:", "Some text", "Some other text", quote: true, heading: true
    end

    context "No Heading" do
      detail "Some text", "Some other text", quote: true, heading: false
    end

    context "Heading, No Details" do
      detail "Some Heading:", quote: true, heading: true
    end

    context "Heading, Empty String" do
      detail "Some Heading:", '', quote: true, heading: true
    end

    context "No Heading, Empty String" do
      detail '', quote: true, heading: false
    end
  end

  context "Default" do
    context "Quote Format, Heading" do
      detail "Some Heading:", "Some text\n", "Some other text\n"
    end

    context "Quote Format, No Heading" do
      detail "Some text\n", "Some other text\n"
    end

    context "Comment Format" do
      detail "Some text", "Some other text"
    end

    context "No Heading" do
      detail ''
    end
  end
end
