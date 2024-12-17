require 'rails_helper'

RSpec.describe(ItemsController, type: :controller) do
  describe "GET #index" do
    it "assigns all items to items" do
      item1 = create(:item) # Use FactoryBot or similar
      item2 = create(:item)
      get :index
      expect(assigns(:items)).to(match_array([ item1, item2 ]))
    end

    it "renders the index template" do
      get :index
      expect(response).to(render_template("index"))
    end
  end

  describe "GET #show" do
    let(:concert) { create(:item) }

    context "when queue is not required" do
      it "assigns the requested concert to @item" do
        get :show, params: { id: item.id }
        expect(assigns(:item)).to(eq(item))
      end
    end

    context "when item is not found" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get(:show, params: { id: -1 }) # An ID that doesn't exist
        }.to(raise_error(ActiveRecord::RecordNotFound))
      end
    end
  end
end
