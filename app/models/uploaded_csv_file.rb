class UploadedCsvFile
  include Mongoid::Document

  field :file, type: String

  mount_uploader :file, CsvFileUploader
end
