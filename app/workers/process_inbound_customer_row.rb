class ProcessInboundCustomerRow

  include Sidekiq::Worker
  sidekiq_options :retry => 1

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(job)
    cipher = Gibberish::AES::CBC.new(ENV['SIDEKIQ_ENCRYPTION_KEY'])
    password = cipher.decrypt(job["password"])
    # do something
    details = {:domain => job["domain"], :username => job["username"], :password => password}
    job["data"]["sheet_id"] = job["data"]["id"]
    job["data"].delete "id"
    #job["data"]["detials"] = details


    data = {
      first_name: job["data"]["first_name"],
      last_name: job["data"]["last_name"],
      external_id: job["data"]["sheet_id"],
      title: job["data"]["title"],
      company: job["data"]["company"]
    }

    # look for our custom fields and add them to the data hash if found
    custom_fields = {}

    job["data"].each do |key, value|
      if key =~ /^custom_/
        custom_fields[key.gsub("custom_","").to_sym] = value unless value.nil? or value == ""
      end
    end

    data[:custom_fields] = custom_fields unless custom_fields == {}

    # look for any address_ columns and add them to the data hash
    address_array = []

    job["data"].each do |key, value|
      if key =~ /^address_/
        type = key.gsub("address_","")
        address_array << {"type": type, "value": value} unless value.nil? or value == ""
      end
    end

    data[:addresses] = address_array unless address_array == []

    # look for any email_ columns and add them to the data hash
    emails_array = []

    job["data"].each do |key, value|
      if key =~ /^email_/
        type = key.gsub("email_","")
        emails_array << {"type": type, "value": value} unless value.nil? or value == ""
      end
    end

    data[:emails] = emails_array unless emails_array == []

    # look for any phone_ columns and add them to the data hash
    phones_array = []

    job["data"].each do |key, value|
      if key =~ /^phone_/
        type = key.gsub("phone_","")
        phones_array << {"type": type, "value": value} unless value.nil? or value == ""
      end
    end

    data[:phone_numbers] = phones_array unless phones_array == []

    DeskApi.configure do |config|
      # basic authentication
      config.username = details[:username]
      config.password = details[:password]
      config.endpoint = "https://#{details[:domain]}.desk.com"
    end

    begin
      new_customer = DeskApi.customers.create(data)
    rescue DeskApi::Error => e
      raise e
    end

  end
end
