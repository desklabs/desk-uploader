class ProcessCompanyRow

  include Sidekiq::Worker
  sidekiq_options :retry => 1
  sidekiq_options queue: 'rows'


  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(row_id)

    row = Row.find(row_id)
    begin
      decoded_row = JSON.parse(row.data)
    rescue
      row[:_failed] = true
      row.save
      return
    end

    details = {:domain => row.uploadedCsvFile.user.domain, :username => row.uploadedCsvFile.user.username, :password => row.uploadedCsvFile.user.password}

    data ={}

    decoded_row.each do |attr|
      case attr[0]
      when "name", "id"
        data[attr[0]] = attr[1]
      when "domains"
        data[:domains] = attr[1].gsub(/\s+/, "") .split(',')
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

    # # look for any address_ columns and add them to the data hash
    # address_array = []

    # decoded_row.each do |attr|
    #   if attr[0] =~ /^address_/
    #     type = attr[0].gsub("address_","")
    #     address_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
    #   end
    # end

    # data[:addresses] = address_array unless address_array == []

    # # look for any email_ columns and add them to the data hash
    # emails_array = []

    # decoded_row.each do |attr|
    #   if attr[0] =~ /^email_/
    #     type = attr[0].gsub("email_","")
    #     emails_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
    #   end
    # end

    # data[:emails] = emails_array unless emails_array == []

    # # look for any phone_ columns and add them to the data hash
    # phones_array = []

    # decoded_row.each do |attr|
    #   if attr[0] =~ /^phone_/
    #     type = attr[0].gsub("phone_","")
    #     phones_array << {"type": type, "value": attr[1]} unless attr[1].nil? or attr[1] == ""
    #   end
    # end

    # data[:phone_numbers] = phones_array unless phones_array == []
    d = DeskApi.configure do |config|
      # basic authentication
      config.username = details[:username]
      config.password = details[:password]
      config.endpoint = "https://#{details[:domain]}.desk.com"
    end

    begin
      new_company = d.companies.create(data)
    rescue DeskApi::Error::TooManyRequests => e
      ProcessCompanyRow.perform_in(e.rate_limit.retry_after, row_id)
    rescue DeskApi::Error => e
      Bugsnag.notify(e)

      #binding.pry
      row[:_failed] = true
      row[:_error] = e.to_s
      row.save
      #raise
    end
  end
end
