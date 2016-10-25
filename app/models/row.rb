class Row
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :data, type: Mongoid::EncryptedString

  scope :failed, ->{ where(:_failed.exists =>true) }

  belongs_to :uploadedCsvFile
end
