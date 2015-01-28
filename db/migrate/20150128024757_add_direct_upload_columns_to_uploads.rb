class AddDirectUploadColumnsToUploads < ActiveRecord::Migration
  def change
    add_reference :uploads, :user, index: true, null: false
    add_column :uploads, :direct_upload_url, :string, null: false
    add_column :uploads, :processed, :boolean, index: true, default: false, null: false
  end
end
