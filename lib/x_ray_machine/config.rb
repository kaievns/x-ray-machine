module XRayMachine

  def self.config(&block)
    yield options
  end

  def self.options
    @options ||= Options.new
  end

  class Options
    COLORS = {
      red:     "\e[31m",
      green:   "\e[32m",
      yellow:  "\e[33m",
      blue:    "\e[34m",
      magenta: "\e[35m",
      cyan:    "\e[36m"
    }

    def initialize
      @streams = {}
    end

    def method_missing(name, config=nil)
      name = name[0, name.size - 1] if name[name.size - 1] == "="
      name = name.to_sym

      if config
        @streams[name] = fill_defaults_for(config)
      else
        @streams[name] ||= generate_options_for(name)
      end
    end

  private

    def generate_options_for(name)
      fill_defaults_for title: name.to_s.gsub(/(^|_)([a-z])/) { |m| $2.upcase }
    end

    def fill_defaults_for(config)
      {
        color: available_colors[0],
        show_in_summary: true
      }.merge config
    end

    def available_colors
      used_colors = @streams.map{|_,o| o[:color] }.compact
      COLORS.keys - used_colors
    end
  end

  class Config
    attr_reader :title, :color, :show_in_summary

    def self.for(stream)
      options = XRayMachine.options.__send__ stream
      title   = options[:title]
      color   = options[:color]
      show_in_summary = options[:show_in_summary]

      new title, color, show_in_summary
    end

    def initialize(title, color, show_in_summary)
      @title = title
      @color = XRayMachine::Options::COLORS[color] || XRayMachine::Options::COLORS[:red]
      @show_in_summary = show_in_summary
    end

    alias :show_in_summary? :show_in_summary

    def to_h
      {title: title, color: color, show_in_summary: show_in_summary}
    end
  end
end
