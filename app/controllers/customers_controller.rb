class CustomersController < ApplicationController
  def index
    #@customers = Customer.all
  end

  def import
    num_imported = Customer.import(params[:file], params[:domain], params[:username], params[:password])
    redirect_to root_url, notice: "CSV queued and is uploading in the background.  You will receive an email when finished.<br/>"
  end
end
