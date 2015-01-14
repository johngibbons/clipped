class EntourageItem < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags

  has_attached_file :image, :styles => { :listing => "500x400>", :thumb => "100x100>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
