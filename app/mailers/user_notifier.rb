class UserNotifier < ApplicationMailer
  include ActionView::Helpers::DateHelper

  default :from => 'do_not_reply@example.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_job_done_email_no_failures(file)

    @this_file = file
    @elapsed_time = distance_of_time_in_words(Time.now - @this_file.created_at)
    @user = @this_file.user
    @total_rows = @this_file.rows.count

    mail( :to => @user.username,
          :subject => 'Import Complete' )
  end

  def send_job_done_email(file)

    @this_file = file
    @elapsed_time = distance_of_time_in_words(Time.now - @this_file.created_at)
    @user = @this_file.user
    @failed_rows = @this_file.rows.failed
    @total_rows = @this_file.rows.count

    if @failed_rows.count > 0

      csv_string = CSV.generate do |csv|

        csv_header_row = []
        JSON.parse(@this_file.rows.failed.first.data).each do |header_row|
          csv_header_row << header_row[0]
        end
        csv_header_row << "_error"
        csv << csv_header_row

        csv_body = []
        @this_file.rows.failed.each do |fr|
          csv_row = []
          JSON.parse(fr.data).each do |detail|
            csv_row << detail[1]
          end
          csv_row << fr._error
          csv << csv_row
        end

      end

      attachments['errors.csv'] = csv_string
    end

    mail( :to => @user.username,
          :subject => 'Import Complete' )
  end

end
