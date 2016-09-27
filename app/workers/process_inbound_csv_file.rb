class ProcessInboundCSVFile

  include Sidekiq::Worker

  def perform(file, domain, username, password)
#    binding.pry
    SmarterCSV.process(file) do |row|
      job = {
        :data => row.first,
        :domain => domain,
        :username => username,
        :password => password
      }
      ProcessInboundCustomerRow.perform_async(job)

    end
  end

end
