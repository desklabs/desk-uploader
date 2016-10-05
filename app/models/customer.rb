class Customer

  def self.import(file, domain, username, password)
    usr = User.create(:username => username, :domain => domain, :password => password)
    u = UploadedCsvFile.create(:file => file)
    usr.uploadedCsvFiles.push(u)
    ProcessInboundCSVFile.perform_async(u.id.to_s)
  end

end
