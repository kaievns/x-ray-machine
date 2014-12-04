module XRayMachine
  class Railtie < Rails::Railtie
    railtie_name :x_ray_machine

    config.before_initialize do |app|
      XRayMachine::LogSubscriber.attach_to :xraymachine

      ActiveSupport.on_load(:action_controller) do
        include XRayMachine::Summary::Runtime

        before_filter do
          XRayMachine::LogSubscriber.reset_runtimes
        end
      end
    end
  end
end
