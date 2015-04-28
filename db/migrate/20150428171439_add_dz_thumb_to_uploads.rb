class AddDzThumbToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :dz_thumb, :string, null: false, default: "/missing.png"
  end
end
