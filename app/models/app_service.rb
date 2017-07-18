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

  def self.permitted_fields
    %i[name expected_response_code expected_response_format expected_response_body environment enabled]
  end

  def delete_status
    status.delete
  end

  def fetch_status
    uris.each do |url|
      response = HTTParty.get(url) rescue false
      status.alive = response.respond_to?(:success?) ? response.success? : response
      status.save!
    end
  end

  def status
    @status ||= Status.where(app_id: id).first || Status.new(app_name: name, app_id: id, env: environment)
  end
end
