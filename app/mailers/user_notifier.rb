class UserNotifier < ApplicationMailer
	  include ActionView::Helpers::DateHelper

  default :from => 'do_not_reply@example.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_job_done_email_no_failures(f_id)

    @this_file = UploadedCsvFile.find(f_id)
    @elapsed_time = distance_of_time_in_words(Time.now - @this_file.created_at)
    @user = @this_file.user
    @failed_rows = @this_file.rows.where(_failed: true)
    @total_rows = @this_file.rows.count
    # csv_string = CSV.generate do |csv|
    #   csv << ["headers"]
    #   failed_rows.each do |fr|
    #     #binding.pry
    #     parsed = JSON.parse(fr)
    #     csv << [parsed["first_name"]]
    #   end
    # end

    mail( :to => @user.username,
          :subject => 'Import Complete' )
  end
end
