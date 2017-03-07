class FilesController < ApplicationController
  def index
    Redis.new.ping

    #@customers = Customer.all
  end

  def import
    Redis.new.ping

    num_imported = UploadedCsvFile.import(
      params[:file],
      params[:domain],
      params[:username],
      params[:password],
      params[:filetype],
      params[:token],
      params[:token_secret],
      params[:consumer_key],
      params[:consumer_secret],
      params[:auth_type]

    )
    redirect_to root_url, notice: "CSV queued and is uploading in the background.  You will receive an email when finished."
  end
end
