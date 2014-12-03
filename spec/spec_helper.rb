require "rails"
require File.dirname(__FILE__)+ "/../lib/x_ray_machine"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
