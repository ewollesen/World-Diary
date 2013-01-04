ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/reporters"
require "minitest/rails/capybara"
require "factories"


class MiniTest::Rails::ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end


MiniTest::Rails.override_testunit!


# If description name ends with 'integration', use this RequestSpec class.
# It has all the integration test goodies.
class RequestSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
end
MiniTest::Spec.register_spec_type /integration$/i, RequestSpec


MiniTest::Reporters.use!


# MiniTest::Unit::TestCase.register_matcher HaveContent, :have_content
# MiniTest::Unit::TestCase.register_matcher :have_selector, :have_selector


DatabaseCleaner.strategy = :truncation
class MiniTest::Spec
  before :each do
    DatabaseCleaner.clean
  end

  after :each do
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end
