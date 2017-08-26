# Model for to store basic info of apps to check the status of
class Service
  include Mongoid::Document

  field :name, type: String
  field :uri, type: String
  field :expected_response_code, type: Integer, default: 200
  field :enabled, type: Boolean, default: false
  field :environment, type: String
  field :alive, type: Boolean

  def self.permitted_fields
    %i[name expected_response_code environment enabled uri]
  end

  def fetch_status
    response = HTTParty.get(uri)
    self.alive = response.success?
    save! if changed?
  end
end
