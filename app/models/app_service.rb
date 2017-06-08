class AppService
  include Mongoid::Document

  field :name, type: String
  field :uris, type: Array, default: []
  field :expected_response_code, type: Integer, default: '200'
  field :expected_response_format, type: String, default: 'json'
  field :expected_response_body, type: String

  def self.permitted_fields
    %i(name uris expected_response_code expected_response_format expected_response_body)
  end
end
