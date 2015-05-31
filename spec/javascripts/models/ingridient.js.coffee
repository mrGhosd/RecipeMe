describe "Ingridient", ->
  describe "#initialize", ->
    describe "params exists", ->
      it "set r@ecipe attribute", ->
        ingridient = new RecipeMe.Models.Ingridient({recipe: 1})
        expect(ingridient.recipe).toEqual(1)

    describe "params doesn't exists", ->
      it "set r@ecipe attribute", ->
        ingridient = new RecipeMe.Models.Ingridient()
        console.log JSON.stringify(ingridient.recipe)
        expect(ingridient.recipe).toBeUndefined()


  describe "#url", ->
    describe "param exists", ->
      it "return url", ->
        ingridient = new RecipeMe.Models.Ingridient({recipe: 1})
        expect(ingridient.url()).toEqual("api/recipes/1/ingridients")

    describe "param doesn't exists", ->
      it "return url", ->
        ingridient = new RecipeMe.Models.Ingridient()
        expect(ingridient.url()).toEqual("api/ingridients")

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @ingridient = new RecipeMe.Models.Ingridient({name: ""})
        @server.respondWith("POST", "/api/categories",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({name: ['cant be blank'] })]);
        @ingridient.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@ingridient.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@ingridient).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).name[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @ingridient = new RecipeMe.Models.Ingridient({name: "Name", size: 200})
        @server.respondWith("POST", "/api/categories",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@ingridient)]);
        @ingridient.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@ingridient.attributes)