class WorkerEnd

  include Sidekiq::Worker

  def perform(file_id)
    this_file = UploadedCsvFile.find(file_id)
    this_user = this_file.user
    failed_rows = this_file.rows.where(_failed: true)

    UserNotifier.send_job_done_email(this_user).deliver_now
    this_user.delete
  end

end
