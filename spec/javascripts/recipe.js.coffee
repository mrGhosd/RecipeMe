describe "Recipe", ->
  it "should retrun a title, which was setted", ->
    recipe = new RecipeMe.Models.Recipe({title: "TestTitle"})
    expect(recipe.get("title")).toBe("TestTitle")