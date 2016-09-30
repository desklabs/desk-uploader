class ProcessInboundCSVFile

  include Sidekiq::Worker

  def perform(domain, username, password, uid)
    #   binding.pry
    uploaded_file = UploadedCsvFile.where(id: uid).first
    jobs = []
    CSV.parse(uploaded_file.file.read, headers: true, :encoding => 'ISO-8859-1') do |row|
      job = {
        :data => row.to_hash,
        :domain => domain,
        :username => username,
        :password => password
      }
      jobs << job
  #    ProcessInboundCustomerRow.perform_async(job)
    end
    CreateJobsForCSVFile.perform_async(jobs, username)
    uploaded_file.destroy
  end

end
