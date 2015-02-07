class Relationship < ActiveRecord::Base
  belongs_to :liker, class_name: "User"
  belongs_to :liked, class_name: "Upload"
  validates :liker_id, presence: true
  validates :liked_id, presence: true
end
