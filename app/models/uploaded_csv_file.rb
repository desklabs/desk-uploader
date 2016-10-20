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
    this_file = UploadedCsvFile.find(options['uid'])
    this_user = this_file.user
    failed_rows = this_file.rows.where(_failed: true)


    csv_string = CSV.generate do |csv|
      csv << ["headers"]
      failed_rows.each do |fr|
        #binding.pry
        parsed = JSON.parse(fr)
        csv << [parsed["first_name"]]
      end
    end
    UserNotifier.send_job_done_email(this_user).deliver_now
    this_user.delete

  end
  def on_success(status, options)

    #binding.pry
    this_file = UploadedCsvFile.find(options['uid'])
    this_user = this_file.user
    failed_rows = this_file.rows.where(_failed: true)


    # csv_string = CSV.generate do |csv|
    #   csv << ["headers"]
    #   failed_rows.each do |fr|
    #     binding.pry
    #     parsed = JSON.parse(fr.data)
    #     csv << [parsed["first_name"]]
    #   end
    # end
    UserNotifier.send_job_done_email(this_user).deliver_now
    this_user.delete
  end

end
