ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# rubocop:disable Style/ClassAndModuleChildren
# rubocop:disable Style/Documentation
class ActiveSupport::TestCase
  # rubocop:enable Style/ClassAndModuleChildren
  # rubocop:enable Style/Documentation

  # Turns response body to json for controller tests
  def body_json
    return nil unless response.present?
    return @json if @json.present?
    @json = JSON.parse(response.body)
  end

  # Params needed to build a settings object
  def settings_params
    { name: 'test', envs: %w[qa test], check_duration: 90 }
  end
end
