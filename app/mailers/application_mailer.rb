class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@clipped.io"
  attachments['logo-header.png'] = File.read('/logo-header.png')
  layout 'mailer'
end
