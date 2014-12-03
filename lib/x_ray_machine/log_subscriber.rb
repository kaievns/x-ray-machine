module XRayMachine
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.runtimes
      Thread.current["x_ray_machine_runtimes"] ||= Hash.new{|k,_| 0}
    end

    def request(event)
      group  = event.payload[:group]
      config = XRayMachine::Config.for(group)

      self.class.runtimes[group] += event.duration

      name  = config.title
      name += " CACHE" if event.payload[:cache]
      name  = '%s (%.1fms)' % [name, event.duration]
      debug "  #{color(name, config.color, true)}  #{event.payload[:query]}"
    end
  end
end
