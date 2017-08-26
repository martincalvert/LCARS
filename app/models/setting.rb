# Setting model used for storign shared environments and other global level settings.
class Setting
  include Mongoid::Document

  field :name, type: String
  field :environments, type: Array, default: []
  field :check_duration, type: Integer, default: 10

  def self.permitted_fields
    %i[name environments check_duration]
  end
end
