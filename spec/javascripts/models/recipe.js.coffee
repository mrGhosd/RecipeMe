describe "Recipe", ->
  describe "base fields", ->
    it "should retrun a title, which was setted", ->
      recipe = new RecipeMe.Models.Recipe({title: "TestTitle"})
      expect(recipe.get("title")).toBe("TestTitle")

    it "should return a description, which was setted", ->
      recipe = new RecipeMe.Models.Recipe({description: "TestDescription"})
      expect(recipe.get("description")).toBe("TestDescription")

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({description: "Desc"})
        @server.respondWith("POST", "/api/recipes",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({title: ['cant be blank'] })]);
        @recipe.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@recipe.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@recipe).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).title[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({title: "Title", description: "Desc", user_id: 1})
        @server.respondWith("POST", "/api/recipes",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@recipe)]);
        @recipe.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@recipe.attributes)

  describe "#parse", ->
    beforeEach ->
      @recipe = new RecipeMe.Models.Recipe({description: "Desc"})
      @comments = new RecipeMe.Collections.Comments()
      @steps = new RecipeMe.Collections.Steps()
      @ingridients = new RecipeMe.Collections.Ingridients()

      @recipe.comments = @comments
      @recipe.steps = @steps
      @recipe.ingridients = @ingridients
      @server = sinon.fakeServer.create()
      @server.respondWith("POST", "/api/recipes/#{@recipe.id}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@recipe)]);

    afterEach ->
      @server.restore()

    describe "fetch server data", ->
      beforeEach ->
        @recipe.fetch({async: false})

      it "has a comments list collection", ->
        expect(@recipe.comments).toEqual(@comments)

      it "has a steps list collection", ->
        expect(@recipe.steps).toEqual(@steps)

      it "has a ingridients list collection", ->
        expect(@recipe.ingridients).toEqual(@ingridients)



