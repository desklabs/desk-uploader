class UploadedCsvFile
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::DateHelper


  field :file, type: String
  field :batch_id, type: String

  belongs_to :user
  has_many :rows, dependent: :delete

  mount_uploader :file, CsvFileUploader



  def on_complete(status, options)

    puts "complete"
    #puts "Uh oh, batch has failures" if status.failures != 0
    this_file = UploadedCsvFile.find(options['uid'])
    if this_file.rows.failed.count == 0
      UserNotifier.send_job_done_email_no_failures(this_file).deliver_now
    else
      UserNotifier.send_job_done_email_failures(this_file).deliver_now
    end
    this_file.user.destroy
  end

end
