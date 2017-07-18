class Status
  include Mongoid::Document

  field :app_name, type: String
  field :app_id, type: BSON::ObjectId
  field :env, type: String
  field :alive, type: Boolean, default: false
end
