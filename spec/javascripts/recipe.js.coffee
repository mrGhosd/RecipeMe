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

      it "doesn't marke recipe as new", ->
        console.log @recipe
        expect(@recipe.isNew()).toBe(false)



#      @server.respondWith(recipe.save)
#      expect(recipe.isNew()).toBe(true)
#      recipe.save()
#      expect(recipe.isNew()).toBe(true)

#      request = @server.requests[0]
#      params = JSON.parse(request.requestBody)
#      console.log @server
#      console.log params

#      expect(request.status).toBe(403)
