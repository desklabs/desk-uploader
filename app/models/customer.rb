class Customer
  # include Mongoid::Document
  # include Mongoid::Attributes::Dynamic
  # belongs_to :desk

  def self.import(file, domain, username, password)
    cipher = Gibberish::AES::CBC.new(ENV['SIDEKIQ_ENCRYPTION_KEY'])
    password = cipher.encrypt(password)
    x = 0
    #CSV.foreach(file.path, headers: true) do |row|
    SmarterCSV.process(file.path) do |row|
      job = {
        :data => row.first,
        :domain => domain,
        :username => username,
        :password => password
      }
      if ProcessInboundCustomerRow.perform_in(10.seconds, job)
        x += 1
      end
    end
    return x
  end
end
