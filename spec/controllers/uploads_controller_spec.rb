require 'rails_helper'

RSpec.describe UploadsController, type: :controller do

  subject(:upload) { build(:upload) }
  subject(:current) { build(:user) }

  context "not logged in" do

    it "redirects create" do
      expect do
        post :create, upload: { direct_upload_url: upload.direct_upload_url }
      end.to_not change{ Upload.count }
      expect(response).to redirect_to login_url
    end

    it "redirects destroy" do
      upload.save!
      expect do
        delete :destroy, id: upload
      end.to_not change{ Upload.count }
      expect(response).to redirect_to login_url
    end

    it "redirects update" do
      upload.save!
      expect(upload.tags.count).to eq(0)
      expect do
        patch :update, id: upload.id, upload: { tag_list: "some tag, another tag, a third" }
      end.to_not change{ upload.reload.tags.count }
      expect(response).to redirect_to login_url
    end
  end

  context "logged in" do

    before(:each) do
      upload.save!
      current.save!
    end

    it "redirects destroy for non owner" do
      log_in_as(current)
      expect do
        delete :destroy, id: upload
      end.to_not change{ Upload.count }
    end

    it "creates own upload" do
      upload.user = current
      upload.save!
      log_in_as(current)
      expect do
        post :create, upload: { direct_upload_url: upload.direct_upload_url }
      end.to change{ Upload.count }.by(1)
    end

    it "updates when owner" do
      upload.user = current
      upload.save!
      log_in_as(current)
      expect do
        xhr :patch, :update, id: upload, upload: { tag_list: "some tag, another tag, a third" }, format: "json"
      end.to change{ upload.reload.tags.count }.by(3)
    end

    it "destroys when owner" do
      upload.user = current
      upload.save!
      log_in_as(current)
      expect do
        delete :destroy, id: upload
      end.to change{ Upload.count }.by(-1)
    end

    it "destroys when admin" do
      current.admin = true
      current.save!
      log_in_as(current)
      upload.save!
      expect do
        delete :destroy, id: upload
      end.to change{ Upload.count }.by(-1)    
    end
    
  end

end
