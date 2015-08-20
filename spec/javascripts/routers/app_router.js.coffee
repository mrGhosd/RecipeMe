describe "Application router", ->
  beforeEach ->
    @router = new RecipeMe.Routers.Recipes()

  describe "#application", ->
    beforeEach ->
      @spy = jasmine.createSpy('application')
      @router.application = @spy.and.callThrough()

    it "fires the index route with a blank hash", ->
      @router.application()
      expect(@spy).toHaveBeenCalled()

  describe "#index", ->
    beforeEach ->
      @spy = jasmine.createSpy('index')
      @router.index = @spy.and.callThrough()

    it "fires the index route with a recipes action", ->
      @router.index()
      expect(@spy).toHaveBeenCalled()

  describe "#newRecipe", ->
    beforeEach ->
      @spy = jasmine.createSpy('newRecipe')
      @router.newRecipe = @spy.and.callThrough()

    it "fires the newRecipe route with a new recipe action", ->
      @router.newRecipe()
      expect(@spy).toHaveBeenCalled()

  describe "#showRecipe", ->
    beforeEach ->
      @spy = jasmine.createSpy('showRecipe')
      @router.showRecipe = @spy.and.callThrough()

    it "fires the showRecipe route with a show recipe action", ->
      @router.showRecipe()
      expect(@spy).toHaveBeenCalled()

  describe "#editRecipe", ->
    beforeEach ->
      @spy = jasmine.createSpy('editRecipe')
      @router.editRecipe = @spy.and.callThrough()

    it "fires the editRecipe route with a edit recipe action", ->
      @router.editRecipe()
      expect(@spy).toHaveBeenCalled()

  describe "#userProfile", ->
    beforeEach ->
      @spy = jasmine.createSpy('userProfile')
      @router.userProfile = @spy.and.callThrough()

    it "fires the userProfile route with a user profile action", ->
      @router.userProfile()
      expect(@spy).toHaveBeenCalled()

  describe "#followersList", ->
    beforeEach ->
      @spy = jasmine.createSpy('followersList')
      @router.followersList = @spy.and.callThrough()

    it "fires the followersList route with a followers list action", ->
      @router.followersList()
      expect(@spy).toHaveBeenCalled()

  describe "#followingList", ->
    beforeEach ->
      @spy = jasmine.createSpy('followingList')
      @router.followingList = @spy.and.callThrough()

    it "fires the followingList route with a following list action", ->
      @router.followingList()
      expect(@spy).toHaveBeenCalled()

  describe "#userFeed", ->
    beforeEach ->
      @spy = jasmine.createSpy('userFeed')
      @router.userFeed = @spy.and.callThrough()

    it "fires the userFeed route with a user feed action", ->
      @router.userFeed()
      expect(@spy).toHaveBeenCalled()

  describe "#searchByTag", ->
    beforeEach ->
      @spy = jasmine.createSpy('searchByTag')
      @router.searchByTag = @spy.and.callThrough()

    it "fires the searchByTag route with a search by tag action", ->
      @router.userFeed()
      expect(@spy).toHaveBeenCalled()

  describe "#searchByIngridient", ->
    beforeEach ->
      @spy = jasmine.createSpy('searchByIngridient')
      @router.searchByIngridient = @spy.and.callThrough()

    it "fires the searchByIngridient route with a search by ingridient action", ->
      @router.searchByIngridient()
      expect(@spy).toHaveBeenCalled()

  describe "#categoriesList", ->
    beforeEach ->
      @spy = jasmine.createSpy('categoriesList')
      @router.categoriesList = @spy.and.callThrough()

    it "fires the categoriesList route with a categories list action", ->
      @router.categoriesList()
      expect(@spy).toHaveBeenCalled()

  describe "#createCategory", ->
    beforeEach ->
      @spy = jasmine.createSpy('createCategory')
      @router.createCategory = @spy.and.callThrough()

    it "fires the createCategory route with a create category action", ->
      @router.createCategory()
      expect(@spy).toHaveBeenCalled()

  describe "#editCategory", ->
    beforeEach ->
      @spy = jasmine.createSpy('editCategory')
      @router.editCategory = @spy.and.callThrough()

    it "fires the editCategory route with a edit category action", ->
      @router.editCategory()
      expect(@spy).toHaveBeenCalled()

  describe "#showCategory", ->
    beforeEach ->
      @spy = jasmine.createSpy('showCategory')
      @router.showCategory = @spy.and.callThrough()

    it "fires the showCategory route with a show category action", ->
      @router.showCategory()
      expect(@spy).toHaveBeenCalled()

  describe "#callbacksList", ->
    beforeEach ->
      @spy = jasmine.createSpy('callbacksList')
      @router.callbacksList = @spy.and.callThrough()

    it "fires the callbacksList route with a callbacks list action", ->
      @router.callbacksList()
      expect(@spy).toHaveBeenCalled()

  describe "#newsList", ->
    beforeEach ->
      @spy = jasmine.createSpy('newsList')
      @router.newsList = @spy.and.callThrough()

    it "fires the newsList route with a news list action", ->
      @router.newsList()
      expect(@spy).toHaveBeenCalled()

  describe "#newNews", ->
    beforeEach ->
      @spy = jasmine.createSpy('newNews')
      @router.newNews = @spy.and.callThrough()

    it "fires the newNews route with a new news action", ->
      @router.newNews()
      expect(@spy).toHaveBeenCalled()

  describe "#showNews", ->
    beforeEach ->
      @spy = jasmine.createSpy('showNews')
      @router.showNews= @spy.and.callThrough()

    it "fires the showNews route with a show news action", ->
      @router.showNews()
      expect(@spy).toHaveBeenCalled()

  describe "#editNews", ->
    beforeEach ->
      @spy = jasmine.createSpy('editNews')
      @router.editNews = @spy.and.callThrough()

    it "fires the editNews route with a edit news action", ->
      @router.editNews()
      expect(@spy).toHaveBeenCalled()