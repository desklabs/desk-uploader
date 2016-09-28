class CustomersController < ApplicationController
  def index
    #@customers = Customer.all
  end

  def import
    num_imported = Customer.import(params[:file], params[:domain], params[:username], params[:password])
    redirect_to root_url, notice: "#{num_imported} rows queued"
  end
end
