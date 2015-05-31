describe "Steps", ->
  describe "#initialize", ->
    describe "not empty params", ->
      it "should set recipe_id and step_id", ->
        step = new RecipeMe.Models.Step({id: 1, recipe_id: 2})
        expect(step.step_id).toEqual(1)
        expect(step.recipe_id).toEqual(2)

    describe "empty params", ->
      it "should set image", ->
        step = new RecipeMe.Models.Step()
        console.log JSON.stringify(step)
        expect(step.get("image")).not.toBeUndefined()

  describe "#url", ->
    describe "step_id exists", ->
      it "return url to particular step", ->
        step = new RecipeMe.Models.Step({id: 1, recipe_id: 2})
        expect(step.url()).toEqual("/api/recipes/2/steps/1")

    describe "step_id doesn't exists", ->
      it "return url to step list", ->
        step = new RecipeMe.Models.Step({recipe_id: 2})
        expect(step.url()).toEqual("/api/recipes/2/steps")

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({id: 1})
        @step = new RecipeMe.Models.Step({recipe_id: @recipe.get("id"), description: ""})
        @server.respondWith("POST", "/api/categories",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({description: ['cant be blank'] })]);
        @step.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@step.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@step).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).description[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({id: 1})
        @step = new RecipeMe.Models.Step({recipe_id: @recipe.get("id"), description: "Desc"})
        @server.respondWith("POST", "/api/categories",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@step)]);
        @step.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@step.attributes)
