class UserNotifier < ApplicationMailer
  default :from => 'do_not_reply@salesforce.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_job_done_email(user)
    @user = user
    mail( :to => @user.username,
          :subject => 'Import Complete' )
  end
end
