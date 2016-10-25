class ProcessInboundCSVFile

  include Sidekiq::Worker

  def perform(uid)
    uploaded_file = UploadedCsvFile.find(id: uid)

    batch = Sidekiq::Batch.new
    batch.description = "ProcessInboundCSVFile"
    batch.on(:complete, UploadedCsvFile, 'uid' => uid)
    uploaded_file.batch_id = batch.bid
    uploaded_file.save
    batch.jobs do

      CSV.parse(uploaded_file.file.read, headers: true, :encoding => 'ISO-8859-1') do |row|
        row["external_id"] = row["id"]
        row.delete "id"
        r = Row.new(:data => row.to_json)
        uploaded_file.rows.push(r)
        ProcessCustomerRow.perform_async(r.id.to_s)
      end

    end
    puts "Just started Batch #{batch.bid}"

  end



end
