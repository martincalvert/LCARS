require 'test_helper'

# Test methods specific to AppService callbacks
class AppServiceTest < ActiveSupport::TestCase
  setup do
    Status.delete_all
    @app_service = AppService.create(name: 'varnish', environment: 'test', enabled: true)
  end

  test 'AppService creation should create Status' do
    assert_equal Status.count, 1
  end

  test 'AppService destruction should destroy Status' do
    assert_equal Status.count, 1
    assert @app_service.destroy
    assert_equal Status.count, 0
  end

  test 'AppService update should update Status' do
    @app_service.name = 'haproxy'
    @app_service.environment = 'qa'
    assert @app_service.save
    status = @app_service.status
    assert_equal @app_service.name, status.app_name
    assert_equal @app_service.environment, status.environment
  end
end
