require "spec_helper"

describe XRayMachine::Summary do

  before do
    XRayMachine.instance_eval { @options = nil }
    XRayMachine::LogSubscriber.reset_runtimes
    XRayMachine::LogSubscriber.runtimes.merge!({
      one: 11, two: 22, three: 33
    })
  end

  describe ".add" do
    let(:payload) { {view_runtime: 123} }

    subject { XRayMachine::Summary.add(payload) }

    it "substracts the custom runtime from the views runtime" do
      expect{ subject }.to change{ payload }.to({view_runtime: 57})
    end

    it "doesn't change the view runtime when it's less than the recorded rintimes" do
      payload[:view_runtime] = 10

      expect{ subject }.not_to change{ payload }
    end

    it "doesn't explode when the view data is missing" do
      payload.delete :view_runtime

      expect{ subject }.not_to raise_error
    end
  end

  describe ".messages" do
    subject { XRayMachine::Summary.messages }

    it "generates a list of summary messages from the recorded runtimes" do
      is_expected.to eq ["One: 11.0ms", "Two: 22.0ms", "Three: 33.0ms"]
    end

    it "respect the title settings" do
      XRayMachine.config{ |c| c.one = {title: "Custom One"} }

      is_expected.to eq ["Custom One: 11.0ms", "Two: 22.0ms", "Three: 33.0ms"]
    end

    it "hides runtimes that are configured to be hidden from the summary" do
      XRayMachine.config{ |c| c.one = {show_in_summary: false} }

      is_expected.to eq ["Two: 22.0ms", "Three: 33.0ms"]
    end
  end

end
