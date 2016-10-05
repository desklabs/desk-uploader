class UploadedCsvFile
  include Mongoid::Document

  field :file, type: String

  belongs_to :user
  has_many :rows

  mount_uploader :file, CsvFileUploader
end
