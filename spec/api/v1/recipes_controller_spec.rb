require 'rails_helper'

describe "API Recipes controller" do
  let!(:access_token) { create :access_token }
  let!(:user) { create :user }


  context "unauthorized" do
    let!(:api_path) { "/api/v1/recipes" }
    it_behaves_like "API Authenticable"
  end


  describe "GET #index" do
    let!(:category) { create :category }
    let!(:recipes) { create_list :recipe, 12, user_id: user.id, category_id: category.id }
    let!(:recipe) { recipes.last }

    let!(:step) { create :step, recipe_id: recipe.id }
    # let!(:image) { create :image, imageable_id: step.id, imageable_type: "Step"}

    let!(:ingridient) { create :ingridient }
    let!(:recipe_ingridient) { create :recipe_ingridient, recipe_id: recipe.id, ingridient_id: ingridient.id }

    before { get "/api/v1/recipes", access_token: access_token.token, format: :json }

    %w(id title description rate user image persons difficult time).each do |attr|
      it "recipe in recipes list contains #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("#{recipes.index(recipe)}/#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
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

    before { get "/api/v1/recipes/#{recipe.id}", access_token: access_token.token, format: :json }

    %w(id title description rate user image persons difficult time steps_list ingridients_list comments_list).each do |attr|
      it "recipe contains #{attr}" do
        expect(response.body).to be_json_eql(recipe.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    context "steps" do
      %w(id recipe_id description image).each do |attr|
        it "recipe step contains #{attr}" do
          expect(response.body).to be_json_eql(step.send(attr.to_sym).to_json).at_path("steps_list/0/#{attr}")
        end
      end
    end

    context "ingridients" do
      %w(id name created_at updated_at).each do |attr|
        it "recipe ingridient contains #{attr}" do
          expect(response.body).to be_json_eql(ingridient.send(attr.to_sym).to_json).at_path("ingridients_list/0/#{attr}")
        end
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let!(:image) { create :image }
      before do
        @attrs_hash = {title: "ololo", description: "awdawdawd", persons: 1,
                       time: 1, difficult: "easy",
                       user_id: user.id, image_attributes: {id: image.id, imageable_type: "Recipe", name: image.name}, access_token: access_token.token}
      end
      context "only recipe" do

        it "create a new recipe" do
          expect {post "/api/v1/recipes", @attrs_hash }.to change(Recipe, :count).by(1)
        end

        it "return status 200" do
          post "/api/v1/recipes", @attrs_hash
          expect(response.status).to eq(200)
        end
      end

      context "recipe with steps" do
        let!(:step_image) { create :image }

        before do
          @attrs_hash = @attrs_hash.merge({steps_attributes: [{description: "Desc", image: {id: step_image.id, name: step_image.name}}]})
        end

        it "create a new recipe with steps" do
          expect {post "/api/v1/recipes", @attrs_hash }.to change(Step, :count).by(1)
        end

        it "return status 200" do
          post "/api/v1/recipes", @attrs_hash
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

          subject { lambda { post "/api/v1/recipes", @attrs_hash } }

          it { should change {RecipeIngridient.count}.by 1 }
          it { should change {Ingridient.count}.by 0 }

        end

        context "new ingridient" do
          subject { lambda { post "/api/v1/recipes", @attrs_hash } }

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
                       user_id: user.id,
                       image_attributes: {id: image.id, imageable_type: "Recipe", name: image.name}, access_token: access_token.token}
      end

      context "single recipe" do
        it "doesn't create a new recipe" do
          expect{post "/api/v1/recipes", @attrs_hash}.to change(Recipe, :count).by(0)
        end

        it "return new recipe errors" do
          post "/api/v1/recipes", @attrs_hash
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
          expect {post "/api/v1/recipes", @attrs_hash }.to change(Step, :count).by(0)
        end

        it "return error's hash" do
          post "/api/v1/recipes", @attrs_hash
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

          subject { lambda { post "/api/v1/recipes", @attrs_hash } }

          it { should change {RecipeIngridient.count}.by 0 }
          it { should change {Ingridient.count}.by 0 }

          it "return error's hash" do
            post "/api/v1/recipes", @attrs_hash
            expect(JSON.parse(response.body)).to have_key("ingridients")
          end
        end
      end
    end
  end
end