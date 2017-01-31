class FilesController < ApplicationController
  def index
    #@customers = Customer.all
  end

  def import
    Redis.new.ping
    num_imported = UploadedCsvFile.import(params[:file], params[:domain], params[:username], params[:password], params[:filetype])
    redirect_to root_url, notice: "CSV queued and is uploading in the background.  You will receive an email when finished."
  end
end
