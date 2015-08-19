describe "Application router", ->
  describe "#application", ->
    beforeEach ->
      @test = null
      @router = new RecipeMe.Routers.Recipes()
      spyOn(@router, 'application')

    it "fires the index route with a blank hash", ->
      @router.application()
      expect(@router.application).toHaveBeenCalled()