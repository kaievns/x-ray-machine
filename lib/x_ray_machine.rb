module XRayMachine
  # x-ray all everything!
end

require_relative "./x_ray_machine/version"
require_relative "./x_ray_machine/x_ray"
require_relative "./x_ray_machine/config"
require_relative "./x_ray_machine/log_subscriber"
require_relative "./x_ray_machine/summary"
require_relative "./x_ray_machine/railtie"

XRay = XRayMachine::XRay
