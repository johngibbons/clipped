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
      expect do
        delete :destroy, id: upload
      end.to change{ Upload.count }.by(-1)    
    end
    
  end

end
