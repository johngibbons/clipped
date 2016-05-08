class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@clipped.io"

  def mailer
    attachments['logo-header.png'] = File.read('/logo-header.png')
  end
end
