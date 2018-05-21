RSpec.describe Marvel do
  it "has a version number" do
    expect(Marvel::VERSION).not_to be nil
  end

  it "exists" do
    expect(Marvel::Character).not_to be nil
  end
end
