require 'rails_helper'

shared_examples_for "Rating" do

  context "successfull update" do
    it "successfully update rate" do
      rate = object.rate
      request
      object.reload
      expect(object.rate).to eq(rate + 1)
    end

    it "render new entity rate" do
      request
      expect(response.status).to eq(200)
    end
  end

end