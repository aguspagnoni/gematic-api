class ApplicationMailer < ActionMailer::Base
  # default from: 'no-reply@gematic.com.ar'
  default from: 'postmaster@gematic.com.ar'
  layout 'mailer'
end
