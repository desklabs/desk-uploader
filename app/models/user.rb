class User
  include Mongoid::Document

  field :username, type: Mongoid::EncryptedString
  field :domain, type: Mongoid::EncryptedString
  field :password, type: Mongoid::EncryptedString

  has_many :uploadedCsvFiles

end
