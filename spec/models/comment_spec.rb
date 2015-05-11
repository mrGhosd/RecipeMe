require 'rails_helper'

describe Comment do
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id }

  it { should belong_to :user }
  it { should belong_to :recipe }

  it { should validate_presence_of :text }

  describe ".update_comment" do

    it "create event for comment aithor's followers" do
      expect { create :comment, recipe_id: recipe.id, user_id: user.id }.to change(CommentUpdate, :count).by(1)
    end
  end
end