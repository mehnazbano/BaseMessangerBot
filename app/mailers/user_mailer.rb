class UserMailer < ApplicationMailer
	default from: "mehnaz.bano@tcs.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email') do |format|
      format.html { render 'sample_email' }
    end
  end

end
