class WorkerEnd

  include Sidekiq::Worker

  def perform(file_id)
  	this_file = UploadedCsvFile.find(file_id)
    this_user = this_file.user
    failed_rows = this_file.rows.where(_failed: true)

    puts "Sending email to #{this_user.username}.  #{failed_rows.count} rows failed"
this_user.delete
  end

end
