require 'rails_helper'

describe RecipesController do
  let!(:user) { create :user }
  before do
    login_as user
  end

  describe "POST #rating" do
    let!(:object) { create :recipe, user_id: user.id }
    let!(:request) { post :rating, recipe_id: object.id }
    it_behaves_like "Rating"
  end

  describe "GET #index" do
    let!(:recipes_first_page) { create_list :recipe, 12, user_id: user.id }
    let!(:recipes_second_page) { create_list :recipe, 12, user_id: user.id }
    let!(:recipe) { recipes_first_page.first }
    before { get :index }

    context "single recipe" do
      %w(id title user_id rate image comments_count).each do |attr|
        it "recipe attributes contain #{attr}" do
          expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it "render recipes as json" do
        expect(response.status).to eq(200)
      end
    end

    context "pagination" do
      let!(:json_params) { {only: [:title, :id, :user_id, :rate, :comments_count], methods: [:image]} }

      it "load first page" do
        get :index, page: 1
        expect(response.body).to eq(recipes_first_page.to_json(json_params))
      end

      it "load second page" do
        get :index, page: 2
        expect(response.body).to eq(recipes_second_page.to_json(json_params))
      end
    end
  end

  describe "GET #show" do
    let!(:category) { create :category }
    let!(:recipe) { create :recipe, user_id: user.id, category_id: category.id }
    let!(:step){ create :step, recipe_id: recipe.id }
    let!(:comment) { create :comment, recipe_id: recipe.id, user_id: user.id }
    let!(:ingridient) { create :ingridient }
    let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }
    let!(:image) { create :image, imageable_id: recipe.id, imageable_type: recipe.class.to_s }

    before {
      recipe.reload
      get :show, id: recipe.id, format: :json
    }

    %w(id title description tag_list user_id rate image comments_list steps_list ingridients_list user created_at_h).each do |attr|
      it "recipe attributes contain #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    context "comments" do

      it "included comments" do
        expect(response.body).to have_json_size(1).at_path("comments_list")
      end

      %w(id user_id recipe_id text created_at updated_at rate).each do |attr|
        it "recipe comment contain #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments_list/0/#{attr}")
        end
      end
    end

    context "ingridients" do

      it "included ingridients" do
        expect(response.body).to have_json_size(1).at_path("ingridients_list")
      end

      %w(id name created_at updated_at).each do |attr|
        it "recipe ingridient contain #{attr}" do
          expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("ingridients_list/0/#{attr}")
        end
      end
    end

    context "steps" do


      it "included steps" do
        expect(response.body).to have_json_size(1).at_path("steps_list")
      end

      %w(id recipe_id description created_at updated_at).each do |attr|
        it "recipe step contain #{attr}" do
          expect(response.body).to be_json_eql(step.send(attr.to_sym).to_json).at_path("steps_list/0/#{attr}")
        end
      end

    end

    context "image" do
      it "included image" do
        expect(response.body).to have_json_size(6).at_path("image")
      end

      %w(id imageable_type imageable_id).each do |attr|
        it "recipe image contain #{attr}" do
          expect(response.body).to be_json_eql(recipe.image.send(attr.to_sym).to_json).at_path("image/#{attr}")
        end
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "PUT #update" do
    let!(:category) { create :category }
    let!(:recipe) { create :recipe, user_id: user.id, category_id: category.id }
    let!(:step){ create :step, recipe_id: recipe.id }
    let!(:ingridient) { create :ingridient }
    let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }
    context "with valid attributes" do
      before do
        @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes})
      end

      context "only recipe" do
        before { @attrs_hash[:title] = "NewTitle" }

        it "update single recipe" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.title).to eq("NewTitle")
        end
      end

      context "recipe and step" do
        before do
          @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes, steps_attributes: [step.attributes]})
          @attrs_hash[:steps_attributes].first['description'] = "NewDesc"
        end

        it "update recipe step" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.steps.first.description).to eq("NewDesc")
        end
      end

      context "recipe and ingridient" do
        let!(:new_ingridient) { create :ingridient, name: "www" }
        before do
          @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes, recipe_ingridients_attributes: [{size: recipe_ingridient.size, ingiridient_attributes: new_ingridient.attributes}]})
        end

        it "create new ingridient for recipe" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.recipe_ingridients.count).to eq(2)
        end
      end

      it "return just updated recipe" do
        post :create, @attrs_hash
        expect(response.status).to eq(200)
      end
    end


    context "with invalid attributes" do
      before do
        @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes})
      end

      context "single recipe" do
        before { @attrs_hash[:title] = "" }

        it "doesn't update attributes of recipe" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.title).to eq(recipe.title)
        end

        it "return recipe error" do
          put :update, @attrs_hash
          recipe.reload
          expect(JSON.parse(response.body)).to have_key("title")
        end
      end

      context "recipes step" do
        before do
          # recipe.steps << new_step
          @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes, steps_attributes: [step.attributes]})
          @attrs_hash[:steps_attributes].first['description'] = ""
        end

        it "doesn't update step attributes of recipe" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.steps.first.description).to eq(recipe.steps.first.description)
        end

        it "return step error" do
          put :update, @attrs_hash
          recipe.reload
          expect(JSON.parse(response.body)).to have_key("steps")
        end
      end

      context "recipes ingridients" do
        before do
          @attrs_hash = recipe.attributes.merge({image_attributes: recipe.image.attributes, recipe_ingridients_attributes: [{size: recipe_ingridient.size, ingiridient_attributes: ingridient.attributes}]})
          @attrs_hash[:recipe_ingridients_attributes].first['size'] = ''
        end

        it "doesn't update ingridient attributes of recipe" do
          put :update, @attrs_hash
          recipe.reload
          expect(recipe.recipe_ingridients.first.size).to eq(recipe.recipe_ingridients.first.size)
          expect(recipe.recipe_ingridients.count).to eq(1)
        end

        it "return ingridient error" do
          put :update, @attrs_hash
          recipe.reload
          expect(JSON.parse(response.body)).to have_key("ingridients")
        end
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let!(:image) { create :image }
      before do
        @attrs_hash = {title: "ololo", description: "awdawdawd", persons: 1,
                       time: 1, difficult: "easy",
                       user_id: user.id, image_attributes: {id: image.id, imageable_type: "Recipe", name: image.name}}
      end
      context "only recipe" do

        it "create a new recipe" do
          expect {post :create, @attrs_hash }.to change(Recipe, :count).by(1)
        end

        it "return status 200" do
          post :create, @attrs_hash
          expect(response.status).to eq(200)
        end
      end

      context "recipe with steps" do
        let!(:step_image) { create :image }

        before do
          @attrs_hash = @attrs_hash.merge({steps_attributes: [{description: "Desc", image: {id: step_image.id, name: step_image.name}}]})
        end

        it "create a new recipe with steps" do
          expect {post :create, @attrs_hash }.to change(Step, :count).by(1)
        end

        it "return status 200" do
          post :create, @attrs_hash
          expect(response.status).to eq(200)
        end
      end

      context "recipe with ingridients" do
        before do
          @attrs_hash = @attrs_hash.merge({recipe_ingridients_attributes: [{size: 1, ingridient_attributes: {name: "Avokado"}}]})
        end

        context "ingridient already exists" do
          let!(:ingridient) { create :ingridient }

          before do
            @attrs_hash[:recipe_ingridients_attributes].first[:ingridient_attributes][:name] = ingridient.name
          end

          subject { lambda { post :create, @attrs_hash } }

          it { should change {RecipeIngridient.count}.by 1 }
          it { should change {Ingridient.count}.by 0 }

        end

        context "new ingridient" do
          subject { lambda { post :create, @attrs_hash } }

          it { should change {RecipeIngridient.count}.by 1 }
          it { should change {Ingridient.count}.by 1 }
        end
      end
    end

    context "with invalid attributes" do
      let!(:image) { create :image }
      before do
        @attrs_hash = {title: "", description: "awdawdawd", persons: 1,
                       time: 1, difficult: "easy",
                       user_id: user.id, image_attributes: {id: image.id, imageable_type: "Recipe", name: image.name}}
      end

      context "single recipe" do
        it "doesn't create a new recipe" do
          expect{post :create, @attrs_hash}.to change(Recipe, :count).by(0)
        end

        it "return new recipe errors" do
          post :create, @attrs_hash
          expect(JSON.parse(response.body)).to have_key("title")
        end
      end

      context "recipe with steps" do
        let!(:step_image) { create :image }

        before do
          @attrs_hash[:title] = "Title"
          @attrs_hash = @attrs_hash.merge({steps_attributes: [{description: "", image: {id: step_image.id, name: step_image.name}}]})
        end

        it "doesn't a new recipe and steps" do
          expect {post :create, @attrs_hash }.to change(Step, :count).by(0)
        end

        it "return error's hash" do
          post :create, @attrs_hash
          expect(JSON.parse(response.body)).to have_key("steps")
        end
      end

      context "recipe with ingridients" do
        before do
          @attrs_hash = @attrs_hash.merge({recipe_ingridients_attributes: [{size: "", ingridient_attributes: {name: "a"}}]})
        end

        context "doesn't create recipe and ingridient" do
          let!(:ingridient) { create :ingridient }

          before do
            @attrs_hash[:title] = "Title"
            @attrs_hash[:recipe_ingridients_attributes].first[:ingridient_attributes][:name] = ingridient.name
          end

          subject { lambda { post :create, @attrs_hash } }

          it { should change {RecipeIngridient.count}.by 0 }
          it { should change {Ingridient.count}.by 0 }

          it "return error's hash" do
            post :create, @attrs_hash
            expect(JSON.parse(response.body)).to have_key("ingridients")
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:category) { create :category }
    let!(:user) { create :user }
    let!(:recipe) { create :recipe, user_id: user.id, category_id: category.id }
    it "delete selected recipe" do
      expect{delete :destroy,
      id: recipe.id}.to change(Recipe, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy,
      id: recipe.id
      expect(response.status).to eq(200)
    end
  end
end