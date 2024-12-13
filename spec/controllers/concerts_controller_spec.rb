require 'rails_helper'

RSpec.describe ConcertsController, type: :controller do
  describe "GET #index" do
    it "assigns all concerts to @concerts" do
      concert1 = create(:concert) # Use FactoryBot or similar
      concert2 = create(:concert)
      get :index
      expect(assigns(:concerts)).to match_array([ concert1, concert2 ])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    let(:concert) { create(:concert) }

    context "when queue is not required" do
      it "assigns the requested concert to @concert" do
        get :show, params: { id: concert.id }
        expect(assigns(:concert)).to eq(concert)
      end
    end

    context "when concert is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { id: -1 } # An ID that doesn't exist
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
