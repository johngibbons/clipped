class AddPerspectiveToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :perspective, :integer, index: true
  end
end
