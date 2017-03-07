class User
  include Mongoid::Document

  field :auth_type, type: String
  field :username, type: Mongoid::EncryptedString
  field :password, type: Mongoid::EncryptedString

  field :token, type: Mongoid::EncryptedString
  field :token_secret, type: Mongoid::EncryptedString
  field :consumer_key, type: Mongoid::EncryptedString
  field :consumer_secret, type: Mongoid::EncryptedString

  field :domain, type: Mongoid::EncryptedString


  has_many :uploadedCsvFiles, dependent: :destroy

end
