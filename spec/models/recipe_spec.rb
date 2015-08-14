require 'rails_helper'

describe Recipe do
  let!(:category) { create :category }
  let!(:user) { create :user }
  let!(:recipe) { create :recipe, user_id: user.id, category_id: category.id }

  it { should belong_to :category }
  it { should belong_to :user }
  it { should have_many :ingridients }
  it { should have_many :steps }
  it { should have_many :comments }
  it { should have_many :taggings }
  it { should have_many :recipe_ingridients }
  it { should have_one :image}

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  describe "#tag_list" do
    let!(:tag_list) { ActsAsTaggableOn::Tag.create(name: "tag") }

    before do
      recipe.tags << tag_list
    end

    it "return a string from tags" do
      expect(recipe.tag_list).to eq(tag_list.name)
    end
  end

  describe "#tag_list=" do
    it "create or find tags" do
      expect{ recipe.tag_list = "1, 2, 3, 4, 5" }.to change(ActsAsTaggableOn::Tag, :count).by(5)
    end
  end

  describe "#comments_list" do
    let!(:diff_user) { create :user }
    let!(:diff_recipe) { create :recipe, user_id: diff_user.id, category_id: category.id }
    let!(:comment) { create :comment, user_id: user.id, recipe_id: recipe.id }
    let!(:diff_comment) { create :comment, user_id: diff_user.id, recipe_id: diff_recipe.id }

    it "return list of comments for particular recipe" do
      expect(recipe.comments_list).to match_array([comment])
    end
  end

  describe "#steps_list" do
    let!(:step) { create :step, recipe_id: recipe.id }
    let!(:image) { create :image, imageable_id: step.id, imageable_type: step.class.to_s }
    let!(:diff_recipe) { create :recipe, user_id: user.id }
    let!(:diff_step) { create :step, recipe_id: diff_recipe.id }

    it "return list of steps for particular recipe" do
      expect(recipe.steps_list).to match_array([step.as_json(methods: :image)])
    end
  end

  describe "#ingridients_list" do
    let!(:ingridient) { create :ingridient }
    let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }
    let!(:diff_ingridient) { create :ingridient, name: "lool" }

    it "return ingridient attributes with size" do
      recipe.reload
      expect(recipe.ingridients_list).to match_array([recipe.ingridients.first.attributes.merge(size: recipe.recipe_ingridients.last.size,
                                                      recipe: recipe.id)])
    end
  end

  describe "#created_at_h" do
    it "return humanized create time" do
      expect(recipe.created_at_h).to eq(recipe.created_at.strftime('%H:%M:%S %d.%m.%Y'))
    end
  end

end
