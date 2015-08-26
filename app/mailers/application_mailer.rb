class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@clipped.io"
  return_path: 
  layout 'mailer'
end
