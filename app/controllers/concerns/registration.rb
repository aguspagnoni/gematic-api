module Registration
  extend ActiveSupport::Concern

  class_methods do
    private

    def send_confirmation_mail(user)
      ConfirmationMailer.deliver_later(confirmation_link(user))
    end

    def confirmation_link(user)
      [Rails.application.secrets.app_name, 'users', 'confirm'].join('/') +
      '?' +
      "email=#{user.email}&token=#{token_for(user)}"
    end

    def user_from(email, token)
      return if (user = User.find_by(email: email)).nil?
      return user if token_for(user) == token
    end

    def token_for(user)
      Digest::SHA1.hexdigest(user.password_digest)
    end
  end
end
