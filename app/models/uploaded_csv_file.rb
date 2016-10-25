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
    puts "Uh oh, batch has failures" if status.failures != 0
    this_file = UploadedCsvFile.find(options['uid'])
    this_user = this_file.user

    UserNotifier.send_job_done_email(options['uid']).deliver_now
    this_user.destroy


  end

end
