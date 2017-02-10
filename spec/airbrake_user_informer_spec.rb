require "spec_helper"

SingleCov.covered!

describe AirbrakeUserInformer do
  it "has a VERSION" do
    expect(AirbrakeUserInformer::VERSION).to match(/^[\.\da-z]+$/)
  end
end
