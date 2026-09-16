class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "MySweetPlace <noreply@mysweetplace.org>")
  layout "mailer"
end
