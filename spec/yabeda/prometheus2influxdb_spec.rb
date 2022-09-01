# frozen_string_literal: true

RSpec.describe Yabeda::Prometheus2InfluxDB do
  it "has a version number" do
    expect(Yabeda::Prometheus2InfluxDB::VERSION).not_to be nil
  end
end
