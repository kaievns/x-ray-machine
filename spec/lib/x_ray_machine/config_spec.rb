require "spec_helper"

describe XRayMachine::Config do

  before { XRayMachine.instance_eval{ @options = nil } }

  describe ".config" do

    it "allows to config things" do
      XRayMachine.config do |config|
        config.thing = {title: "Thingy"}
      end

      expect(XRayMachine.options.instance_variable_get("@streams")).to eq({
        thing: {title: "Thingy", color: :red, show_in_summary: true}
      })
    end

    it "allows to override colors and the summary settings" do
      XRayMachine.config do |config|
        config.thing = {title: "Thingy", color: :yellow, show_in_summary: false}
      end

      expect(XRayMachine.options.instance_variable_get("@streams")).to eq({
        thing: {title: "Thingy", color: :yellow, show_in_summary: false}
      })
    end

  end

  describe ".for" do
    subject { XRayMachine::Config.for("some_thing").to_h }

    it "generates a new config if the settings are missing" do
      is_expected.to eq({title: "SomeThing", color: "\e[31m", show_in_summary: true})
    end

    it "uses the user settings when it configured" do
      XRayMachine.config { |c| c.some_thing = {title: "ST", color: :yellow} }

      is_expected.to eq({title: "ST", color: "\e[33m", show_in_summary: true})
    end

    it "returns the same object every time" do
      is_expected.to eq(XRayMachine::Config.for("some_thing").to_h)
    end

    it "picks different colors for different things" do
      colors = (1..3).to_a.map{|i| XRayMachine::Config.for("thing_#{i}").color }
      expect(colors).to eq ["\e[31m", "\e[32m", "\e[33m"]
    end

  end

end
