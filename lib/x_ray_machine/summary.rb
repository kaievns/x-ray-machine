module XRayMachine
  class Summary
    def self.add(payload)
      payload_sum = XRayMachine::LogSubscriber.runtimes.map{|k,v| v}.inject(0){|a,b| a+b}

      # most of the times things are lazyloaded
      if payload[:view_runtime] && payload[:view_runtime] > payload_sum
        payload[:view_runtime] -= payload_sum
      end
    end

    def self.messages
      XRayMachine::LogSubscriber.runtimes.map do |stream_name, duration|
        stream = XRayMachine::Config.for(stream_name)
        if stream.show_in_summary?
          "%s: %.1fms" % [stream.title, duration]
        end
      end.compact
    end

    module Runtime
      extend ActiveSupport::Concern

    protected

      def append_info_to_payload(payload)
        super.tap do
          XRayMachine::Summary.add(payload)
        end
      end

      module ClassMethods
        def log_process_action(payload)
          super.tap do |messages|
            XRayMachine::Summary.messages.each do |xray_message|
              messages << xray_message
            end
          end
        end
      end
    end
  end
end
