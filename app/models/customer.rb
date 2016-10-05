class Customer
  # include Mongoid::Document
  # include Mongoid::Attributes::Dynamic
  # belongs_to :desk

  def self.import(file, domain, username, password)

    usr = User.create(:username => username, :domain => domain, :password => password)

    # cipher = Gibberish::AES::CBC.new(ENV['SIDEKIQ_ENCRYPTION_KEY'])
    # password = cipher.encrypt(password)
    u = UploadedCsvFile.create(:file => file)

    usr.uploadedCsvFiles.push(u)
    #ProcessCustomerFile.perform_async(u.id.to_s)
    ProcessInboundCSVFile.perform_async(u.id.to_s)
    #ProcessInboundCSVFile.perform_async(domain, username, password, u.id.to_s)
  end

end
