require 'rails_helper'

RSpec.describe(ItemsController, type: :controller) do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to(render_template("index"))
    end

    it "assigns all items to @items" do
      travel_to Time.zone.local(2024, 1, 1, 12, 0, 0)

      item1 = create(:item, sale_start_time: 1.day.from_now, valid_until: 2.weeks.from_now)
      item2 = create(:item, sale_start_time: 1.day.from_now, valid_until: 2.weeks.from_now)

      get :index

      puts "Total items in database: #{Item.count}"
      puts "Items returned by controller: #{assigns(:items).inspect}"

      expect(assigns(:items)).to(match_array([ item1, item2 ]))

      travel_back
    end
  end

  describe "GET #show" do
    before do
      travel_to Time.zone.local(2024, 1, 1, 12, 0, 0)
    end

    after do
      travel_back
    end

    let(:item) do
      create(:item,
             valid_until: 2.weeks.from_now,
             sale_start_time: 1.day.from_now,
             available_items: 1)
    end

    context "when item creation passes validations" do
      it "assigns the requested item to @item" do
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
