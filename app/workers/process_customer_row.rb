class ProcessCustomerRow

  include Sidekiq::Worker
  sidekiq_options :retry => 1

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(row_id, user_id)

    row = Row.find(row_id)

    decoded_row = JSON.parse(row.data)

    details = {:domain => row.uploadedCsvFile.user.domain, :username => row.uploadedCsvFile.user.username, :password => row.uploadedCsvFile.user.password}

    data ={}

    decoded_row.each do |attr|
      case attr[0]
      when "first_name", "last_name", "external_id", "title", "company"
        data[attr[0]] = attr[1]
      end

    end


    # look for our custom fields and add them to the data hash if found
    custom_fields = {}
    decoded_row.each do |attr|
      if attr[0] =~ /^custom_/
        custom_fields[attr[0].gsub("custom_","").to_sym] = attr[1] unless attr[1].nil? or attr[1] == ""
      end
    end

    data[:custom_fields] = custom_fields unless custom_fields == {}

    # look for any address_ columns and add them to the data hash
    address_array = []

    decoded_row.each do |attr|
      if attr[0] =~ /^address_/
        type = attr[0].gsub("address_","")
        address_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
      end
    end

    data[:addresses] = address_array unless address_array == []

    # look for any email_ columns and add them to the data hash
    emails_array = []

    decoded_row.each do |attr|
      if attr[0] =~ /^email_/
        type = attr[0].gsub("email_","")
        emails_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
      end
    end

    data[:emails] = emails_array unless emails_array == []

    # look for any phone_ columns and add them to the data hash
    phones_array = []

    decoded_row.each do |attr|
      if attr[0] =~ /^phone_/
        type = attr[0].gsub("phone_","")
        phones_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
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
      row.delete
    rescue DeskApi::Error => e
      row[:_failed] = true
      row.save
    end

  end
end
