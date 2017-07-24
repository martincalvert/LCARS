# Model to store the each apps current status
class Status
  include Mongoid::Document

  field :app_name, type: String
  field :app_id, type: BSON::ObjectId
  field :environment, type: String
  field :alive, type: Boolean, default: false
  field :enabled, type: Boolean, default: false
end
