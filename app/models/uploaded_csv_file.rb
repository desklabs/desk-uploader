class UploadedCsvFile
  include Mongoid::Document

  field :file, type: String
  field :batch_id, type: String

  belongs_to :user
  has_many :rows, dependent: :delete

  mount_uploader :file, CsvFileUploader



  def on_complete(status, options)
    puts "***************************"
    puts "***************************"
    puts "***************************"
    puts "***************************"
    puts "Uh oh, batch has failures" if status.failures != 0
    puts "***************************"
    puts "***************************"
    puts "***************************"
    puts "***************************"
    puts status.data
    puts status.failure_info # an array of failed jobs

  end
  def on_success(status, options)


    this_file = UploadedCsvFile.find(options['uid'])
    this_user = this_file.user
    failed_rows = this_file.rows.where(_failed: true)

    UserNotifier.send_job_done_email(this_user).deliver_now
    this_user.delete
  end
end
