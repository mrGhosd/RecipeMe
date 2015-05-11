require 'rails_helper'

describe User do
  let!(:user) { create :user }

  it { should have_many :recipes }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :authorizations }
  it { should have_many :relationships }
  it { should have_many :following }
  it { should have_many :followers }
  it { should have_many :reverse_relationships }

  describe "#follow!" do
    let!(:follower) { create :user }

    it "change user relationships count" do
      expect{ user.follow!(follower) }.to change(user.relationships, :count).by(1)
    end
  end

  describe "#unfollow!" do
    let!(:followed) { create :user }

    before do
      user.follow!(followed)
    end

    it "decreas user relationships count" do
      expect{ user.unfollow!(followed) }.to change(user.relationships, :count).by(-1)
    end
  end

  describe "followers_list" do
    let!(:follower_1) { create :user }
    let!(:follower_2) { create :user }
    let!(:follower_3) { create :user }

    before do
      follower_1.follow!(user)
      follower_2.follow!(user)
      follower_3.follow!(follower_1)
    end

    it "return order user followers list" do
      expect(user.followers_list).to match_array([follower_2, follower_1])
    end
  end

  describe "following_list" do
    let!(:following_1) { create :user }
    let!(:following_2) { create :user }
    let!(:following_3) { create :user }

    before do
      user.follow!(following_1)
      user.follow!(following_2)
      following_3.follow!(user)
    end

    it "return order user followers list" do
      expect(user.following_list).to match_array([following_2, following_1])
    end
  end

  describe "#is_admin?" do
    let!(:admin) { create :user, role: "admin" }

    it "return true if user role is 'admin'" do
      expect(admin.is_admin?).to eq(true)
    end

    it "return false if user role isn't 'admin'" do
      expect(user.is_admin?).to eq(false)
    end
  end

  describe "#correct_naming" do
    let!(:user_1) { create :user, nickname: "lool" }
    let!(:user_2) { create :user, nickname: "", surname: "1", name: "2"  }
    let!(:user_3) { create :user, nickname: nil, surname: nil, name: nil }

    it "should return nickname if user has a nickname" do
      expect(user_1.correct_naming).to eq(user_1.nickname)
    end

    it "should return splitted string with surname and name " do
      user_2.update(nickname: nil)
      expect(user_2.correct_naming).to eq("#{user_2.surname} #{user_2.name}")
    end

    it "should return user email of surname6 name and nickname are empty" do
      user_3.update(nickname: nil, surname: nil, name: nil)
      expect(user_3.correct_naming).to eq(user_3.email)
    end
  end

  describe "#feed" do
    let!(:recipe) { create :recipe, user_id: user.id }
    let!(:following) { create :user }
    let!(:following_relation) { user.follow!(following) }
    let!(:comment) { create :comment, recipe_id: recipe.id, user_id: following.id  }
    let!(:recipe_update) { create :user_update, user_id: recipe.user_id, update_type: 'create', update_id: recipe.id,
                            update_entity: "Recipe", update_entity_for: "Recipe", type: "RecipeUpdate"}
    let!(:comment_update) { create :user_update, user_id: following.id, update_type: "create", update_id: comment.id,
                                   update_entity: "Comment", update_entity_for: "Comment", type: "CommentUpdate" }
    let!(:correct_feed) { user.feed.map{ |x| x.attributes } }

    it "return last users and his following users updates" do
      expect(recipe_update.attributes.in?(correct_feed)).to eq(true)
      expect(comment_update.attributes.in?(correct_feed)).to eq(true)
    end
  end

  describe "#last_sign_in_at_h" do
    context "user signed in" do
      before { user.last_sign_in_at = Time.zone.now }
      it "return humanized version of last_sign_in_at time" do
        expect(user.last_sign_in_at_h).to eq(user.last_sign_in_at.strftime('%H:%M:%S %d.%m.%Y'))
      end
    end

    context "user doesn't signed in" do
      it "return nil" do
        expect(user.last_sign_in_at_h).to eq(nil)
      end
    end

  end
end