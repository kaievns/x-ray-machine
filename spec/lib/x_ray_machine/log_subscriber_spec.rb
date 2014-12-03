require "spec_helper"

describe XRayMachine::LogSubscriber do
  before { XRayMachine::LogSubscriber.reset_runtimes }

  describe ".runtimes" do
    subject { XRayMachine::LogSubscriber.runtimes }

    it { is_expected.to be_a Hash }
    it { is_expected.to eq({}) }

    it "returns the same object all the time" do
      other_object = XRayMachine::LogSubscriber.runtimes

      is_expected.to be other_object
    end
  end

  describe "#request" do
    let(:subscriber) { XRayMachine::LogSubscriber.new }
    let(:event) { double("Event", duration: 11, payload: payload) }
    let(:payload) { {query: "some/query/data", cache: false, group: "external_api"} }

    subject { subscriber.request(event) }

    before do
      def subscriber.debug(string=nil)
        @debug ||= string
      end
    end

    it "saves the duration in the runtimes list" do
      expect{ subject }.to change{ XRayMachine::LogSubscriber.runtimes }.to({"external_api" => 11})
    end

    it "dumps the data in the debugging stream" do
      expect{ subject }.to change{ subscriber.debug }
        .to("  \e[1m\e[34mExternalApi (11.0ms)\e[0m  some/query/data")
    end

    it "marks things cached when the payload have a cache:true option" do
      payload[:cache] = true

      expect{ subject }.to change{ subscriber.debug }
      .to("  \e[1m\e[34mExternalApi CACHE (11.0ms)\e[0m  some/query/data")
    end
  end
end
