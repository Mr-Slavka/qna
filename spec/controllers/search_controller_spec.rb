require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    subject { get :index, params: { body: "", type: "All"} }

    it "render search template" do
      subject
      expect(response).to render_template :index
    end
  end
end
