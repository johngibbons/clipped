require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  @base_title = "Clipped"
  subject(:upload) { build(:upload) }

  it "gets home page" do
    get :home
    expect(response).to have_http_status(:ok)
  end

  it "gets help page" do
    get :help
    expect(response).to have_http_status(:ok)
  end

  it "gets about page" do
    get :about
    expect(response).to have_http_status(:ok)
  end

  it "gets contact page" do
    get :contact
    expect(response).to have_http_status(:ok)
  end
end
