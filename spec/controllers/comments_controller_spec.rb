require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  subject(:user) { create(:user) }
  subject(:upload) { create(:upload) }
  subject(:comment) { create(:comment, commentee_id: upload.id) }

  it "requires logged in user to create" do
    expect do
      post :create, comment: { commentee_id: upload.id, body: "Test comment" }
    end.to_not change{ Comment.count }

    expect(response).to redirect_to(login_url)
  end

  it "requires logged in user to destroy" do
    comment.save!
    expect do
      delete :destroy, id: comment.id
    end.to_not change{ Comment.count }

    expect(response).to redirect_to(login_url)
  end

  context "user is logged in" do
    before do
      log_in_as(user)
    end

    it "lets logged in user create comments" do
      expect do
        post :create, comment: { commentee_id: upload.id, body: "Test comment" }
      end.to change{ Comment.count }.by(1)
    end

    it "doesn't let logged in user delete other's comments" do
      comment.save!
      expect do
        delete :destroy, id: comment.id
      end.to_not change{ Comment.count }
    end

    it "lets logged in user delete own comments" do
      comment.commenter_id = user.id
      comment.save!
      expect do
        delete :destroy, id: comment.id
      end.to change{ Comment.count }.by(-1)
    end

    it "lets logged in admin user delete comments" do
      user.admin = true
      user.save!
      comment.save!
      expect do
        delete :destroy, id: comment.id
      end.to change{ Comment.count }.by(-1)
    end

  end
end
