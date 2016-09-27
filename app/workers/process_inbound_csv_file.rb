class ProcessInboundCSVFile

  include Sidekiq::Worker

    def perform(file, domain, username, password)
     SmarterCSV.process(file.path) do |row|
      job = {
        :data => row.first,
        :domain => domain,
        :username => username,
        :password => password
      }
      if ProcessInboundCustomerRow.perform_async(job)
        x += 1
      end
    end
    end

end