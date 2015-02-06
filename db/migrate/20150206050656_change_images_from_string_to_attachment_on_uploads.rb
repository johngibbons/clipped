class ChangeImagesFromStringToAttachmentOnUploads < ActiveRecord::Migration
  def change
    remove_column :uploads, :image
    add_attachment :uploads, :image
  end
end
