class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@clipped.io"
  layout 'mailer'
end
