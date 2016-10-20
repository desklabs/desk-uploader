# class ProcessInboundCSVFile

#   include Sidekiq::Worker

#   def perform(uid)
#     uploaded_file = UploadedCsvFile.find(id: uid)

#     jobs = []

#     CSV.parse(uploaded_file.file.read, headers: true, :encoding => 'ISO-8859-1') do |row|
#       row["external_id"] = row["id"]
#       row.delete "id"
#       r = Row.new(:data => row.to_json)
#       uploaded_file.rows.push(r)
#       jobs << r.id.to_s
#     end
#     ProcessCustomerRows.perform_async(jobs, uid)

#   end

# end
