class UploadModerationMailer < ApplicationMailer

  def new_upload_email(upload)
    @upload = upload
    @admins = User.where(admin: true)
    @admins.each do |admin|
      mail(to: admin.email, subject: 'New Clipped Upload To Moderate')
    end
  end

end
