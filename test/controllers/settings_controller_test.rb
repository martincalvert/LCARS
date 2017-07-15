require 'test_helper'

# Test controller functions for settings
class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Setting.delete_all
  end

  test 'should return 404 for no settings' do
    get '/api/v1/settings.json'
    assert_response :not_found
  end

  test 'should create setting' do
    assert_difference('Setting.count') do
      post '/api/v1/settings', params: { settings: settings_params }
    end
    assert_response :success
    assert body_json['saved']
    assert body_json['settings'].present?
  end

  test 'should return 200 for settings' do
    Setting.create(settings_params)

    get '/api/v1/settings.json'
    assert_response :success
    assert body_json['settings'].present?
  end
end
