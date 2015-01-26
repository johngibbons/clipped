class EntourageItem < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags

  is_impressionable

  has_attached_file :image,
    :styles => {:thumb => "350x250#",
    :small => "240x240",
    :large => "640x480"},
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['s3_bucket'],
      :access_key_id => ENV['s3_access_id'],
      :secret_access_key => ENV['s3_secret_key']
    },
    :path => "/:style/:filename"

  validates_attachment :image, :presence => true,
  :content_type => { :content_type => /\Aimage/ },
  :size => { :less_than => 64.megabytes }

  validates :tag_list, presence: true

  enum perspective: [ :front, :front_left, :left, :back_left, :back, :back_right, :right, :front_right, :birds_eye ]
  validates :perspective, presence: true
end
