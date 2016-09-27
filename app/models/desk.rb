class Desk
    include Mongoid::Document

    field :domain, type: String
    field :username, type: String
    field :password, type: Mongoid::EncryptedString
    has_many :customers
end