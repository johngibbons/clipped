class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: "User"
  belongs_to :commentee, class_name: "Upload"
  acts_as_tree order: "created_at DESC", dependent: :destroy

  validates :commenter_id, presence: true
  validates :commentee_id, presence: true
  validates :body, presence: true
end
