class UploadedCsvFile
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::DateHelper


  field :file, type: String
  field :batch_id, type: String
  field :type, type: String

  belongs_to :user
  has_many :rows, dependent: :delete

  mount_uploader :file, CsvFileUploader

  def on_complete(status, options)
    puts "complete"
    this_file = UploadedCsvFile.find(options['uid'])
    UserNotifier.send_job_done_email(this_file).deliver_now
    this_file.user.destroy
  end

  def self.import(file, domain, username, password, filetype, token, token_secret, consumer_key, consumer_secret, auth_type)

    Redis.new.ping


    usr = User.create(
      :username => username,
      :domain => domain,
      :password => password,
      :token => token,
      :token_secret => token_secret,
      :consumer_key => consumer_key,
      :consumer_secret => consumer_secret,
      :auth_type => auth_type
    )
    u = UploadedCsvFile.create(:file => file, :type => filetype)
    usr.uploadedCsvFiles.push(u)

    ProcessInboundCSVFile.perform_async(u.id.to_s)
  end


end
