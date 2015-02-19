require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  it "requires logged in user to create" do
    expect { post :create }.not_to change{ Relationship.count }  
    expect(response).to redirect_to(login_url) 
  end

  it "requires logged in user to destroy" do
    expect { delete :destroy }.not_to change{ Relationship.count }
    expect(response).to redirect_to(login_url) 
  end
end
