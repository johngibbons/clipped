class AddDirectUploadUrlToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :direct_upload_url, :string, null: false
    add_column :uploads, :processed, :boolean, default: false, null: false
  end
end
