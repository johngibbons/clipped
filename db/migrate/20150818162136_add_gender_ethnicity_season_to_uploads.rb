class AddGenderEthnicitySeasonToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :gender, :integer, index: true
    add_column :uploads, :season, :integer, index: true
    add_column :uploads, :ethnicity, :integer, index: true
  end
end
