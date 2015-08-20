describe "Application router", ->
  describe "#application", ->
    beforeEach ->
      @test = null
      @router = new RecipeMe.Routers.Recipes()
      @spy = jasmine.createSpy('application')
      @router.application = @spy.and.callThrough()

    it "fires the index route with a blank hash", ->
      @router.application()
      expect(@spy).toHaveBeenCalled()
