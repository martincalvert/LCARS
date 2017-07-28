# Model for to store basic info of apps to check the status of
class AppService
  include Mongoid::Document

  field :name, type: String
  field :uris, type: Array, default: []
  field :expected_response_code, type: Integer, default: '200'
  field :expected_response_format, type: String, default: 'json'
  field :expected_response_body, type: String
  field :enabled, type: Boolean, default: false
  field :environment, type: String

  before_destroy :delete_status
  after_create :create_status
  after_save :update_status

  def self.permitted_fields
    %i[name expected_response_code expected_response_format expected_response_body environment enabled]
  end

  def delete_status
    status.delete
  end

  def create_status
    Status.create(app_name: name, app_id: id, environment: environment, enabled: enabled)
  end

  def update_status
    status.environment = environment
    status.app_name = name
    status.enabled = enabled
    status.save!
  end

  def fetch_status
    uris.each do |url|
      response = Typhoeus.get(url) rescue false
      alive = response.respond_to?(:success?) ? response.success? : response
      if alive and expected_response_format.present?
        alive = expected_response_format.present? and response.headers['Content-Type'] =~ /#{expected_response_format}/
      end
      if alive and expected_response_body.present?
        alive = expected_response_body.present? and response.body == expected_response_body if alive
      end
      status.alive = alive
      status.save!
    end
  end

  def status
    @status ||= Status.where(app_id: id).first
  end
end
