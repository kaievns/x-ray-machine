require File.dirname(__FILE__)+ '/lib/x_ray_machine/version'

Gem::Specification.new do |spec|
  spec.name          = "x-ray-machine"
  spec.version       = XRayMachine::VERSION
  spec.authors       = ["Nikolay Nemshilov"]
  spec.email         = ["nemshilov@gmail.com"]
  spec.description   = "Better instrumentation/logging utility for Rails"
  spec.summary       = "Better instrumentation/logging utility for Rails. Seriously"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rails', '~> 4.0', '>= 4.0.0'

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rspec",    "~> 3.1"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
end
