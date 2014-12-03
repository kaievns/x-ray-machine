require "spec_helper"

describe XRay do

  before do
    ActiveSupport::Notifications.instance_eval do
      def self.instrument(*args, &block)
        @args = args
        yield
      end
    end
  end

  def active_support_args
    ActiveSupport::Notifications.instance_eval { @args }
  end

  describe ".method_missing" do
    it "runs whatevers" do
      XRay.whatevers "query/data" do
      end

      expect(active_support_args).to eq [
        "request.xraymachine", {group: :whatevers, query: "query/data", cache: false}
      ]
    end

    it "returns whatever the block yields" do
      result = XRay.whatevers("query/data") { "yielded result" }
      expect(result).to eq "yielded result"
    end

    it "sends a ray in and allows to mark it as cached" do
      XRay.whatevers "query/data" do |ray|
        ray.cached = true
      end

      expect(active_support_args).to eq [
        "request.xraymachine", {group: :whatevers, query: "query/data", cache: true}
      ]
    end
  end

end
