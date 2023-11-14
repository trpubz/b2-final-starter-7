require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "Mock action"
    end
  end

  before do
    @holidays = [Holiday.new({localName: "Turkey Day", date: "2023-11-23"}),
      Holiday.new({localName: "Baby Jesus Day", date: "2023-12-25"}),
      Holiday.new({localName: "NYE", date: "2023-12-31"})]

    allow(Rails.cache).to receive(:read).with("holidays").and_return(@holidays)
  end

  it "sets @next_holidays correctly" do
    get :index
    expect(assigns(:next_holidays)).to eq @holidays[0..2]
  end
end
