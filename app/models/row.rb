class Row
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :data, type: Mongoid::EncryptedString
  validates_uniqueness_of :data, case_sensitive: true # Works as expected

  scope :failed, ->{ where(:_failed.exists =>true) }

  belongs_to :uploadedCsvFile
end
