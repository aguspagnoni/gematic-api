class UserMailer < ApplicationMailer

  def confirmation_email(user, confirm_link)
    @user = user
    @confirm_link = confirm_link
    mail(to: user.email, subject: I18n.t('mailers.confirmation_email.subject'))
  end
end
