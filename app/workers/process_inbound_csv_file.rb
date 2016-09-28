class ProcessInboundCSVFile

  include Sidekiq::Worker

  def perform(domain, username, password, uid)
    #   binding.pry
    uploaded_file = UploadedCsvFile.where(id: uid).first
    CSV.parse(uploaded_file.file.read, headers: true, :encoding => 'ISO-8859-1') do |row|
      job = {
        :data => row.to_hash,
        :domain => domain,
        :username => username,
        :password => password
      }
      ProcessInboundCustomerRow.perform_async(job)
    end
    uploaded_file.destroy
  end

end
