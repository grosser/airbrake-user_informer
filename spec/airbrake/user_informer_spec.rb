require "spec_helper"

# SingleCov.covered!

describe Airbrake::UserInformer do
  it "has a VERSION" do
    expect(Airbrake::UserInformer::VERSION).to match(/^[\.\da-z]+$/)
  end
end
