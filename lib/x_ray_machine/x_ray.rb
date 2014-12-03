module XRayMachine
  class XRay
    def cached
      @cached || false
    end

    def cached=(val)
      @cached = val
    end

    alias :cached? :cached

    def self.method_missing(name, query, &block)
      options = {group: name, query: query, cache: false}

      ActiveSupport::Notifications.instrument "request.xraymachine", options do
        ray = XRayMachine::XRay.new

        block.call(ray).tap do |result|
          options[:cache] = true if ray.cached?
        end
      end
    end
  end
end
