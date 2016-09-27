class Customer
  # include Mongoid::Document
  # include Mongoid::Attributes::Dynamic
  # belongs_to :desk

  def self.import(file, domain, username, password)
    cipher = Gibberish::AES::CBC.new(ENV['SIDEKIQ_ENCRYPTION_KEY'])
    password = cipher.encrypt(password)

    ProcessInboundCSVFile.perform_async(file.path, domain, username, password)
  end

  # def self.import(file, domain, username, password)

  #   x = 0

  #   return x
  # end
end
