class ProcessInboundCSVFile

  include Sidekiq::Worker
  sidekiq_options queue: 'files'

  def perform(uid)
    uploaded_file = UploadedCsvFile.find(id: uid)

    batch = Sidekiq::Batch.new
    batch.description = "ProcessInboundCSVFile"
    batch.on(:complete, UploadedCsvFile, 'uid' => uid)
    uploaded_file.batch_id = batch.bid
    uploaded_file.save

    content = uploaded_file.file.read
    detection = CharlockHolmes::EncodingDetector.detect(content)
    utf8_encoded_content = CharlockHolmes::Converter.convert content, detection[:encoding], 'UTF-8'

    batch.jobs do

      CSV.parse(utf8_encoded_content, headers: true, :encoding => 'UTF-8') do |row|
        row["external_id"] = row["id"]
        row.delete "id"
        r = Row.new(:data => row.to_json)
        uploaded_file.rows.push(r)
        case uploaded_file.type
        when "customer"
          ProcessCustomerRow.perform_async(r.id.to_s)
        when "company"
          ProcessCompanyRow.perform_async(r.id.to_s)
        end

      end

    end
    puts "Just started Batch #{batch.bid}"

  end



end
