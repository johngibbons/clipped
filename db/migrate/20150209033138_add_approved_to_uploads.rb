class AddApprovedToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :approved, :boolean, default: false, null: false
  end
end
