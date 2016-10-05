class Row
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :data, type: Mongoid::EncryptedString


  belongs_to :uploadedCsvFile
end
