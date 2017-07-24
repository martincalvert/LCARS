require 'test_helper'

# Test controller functions for settings
class StatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Status.delete_all
    @id = BSON::ObjectId.new
    Status.create(app_name: 'varnish', enabled: true, alive: true, environment: 'test', app_id: @id)
  end

  test 'should return status for given env' do
    get '/api/v1/statuses/test.json'
    assert_response :success
    assert body_json['statuses'].present?

    status = body_json['statuses'].first

    assert_equal status['app_name'], 'varnish'
    assert_equal status['app_id'], @id.as_json
    assert_equal status['enabled'], true
    assert_equal status['alive'], true
    assert_equal status['environment'], 'test'
  end

  test 'should return empty array if no statuses in env' do
    get '/api/v1/statuses/tester.json'
    assert_response :success
    assert_equal body_json['statuses'].class, Array
  end
end
