class AddGenderEthnicitySeasonToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :gender, :integer, index: true
    add_column :uploads, :season, :integer, index: true
    add_column :uploads, :ethnicity, :integer, index: true
    change_column_null(:uploads, :gender, false, 0)
    change_column_null(:uploads, :season, false, 0)
    change_column_null(:uploads, :ethnicity, false, 0)
  end
end
