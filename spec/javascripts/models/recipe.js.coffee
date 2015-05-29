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
      @recipe = new RecipeMe.Models.Recipe({id: 1, description: "Desc"})
      @comments = new RecipeMe.Collections.Comments()
      @steps = new RecipeMe.Collections.Steps()
      @ingridients = new RecipeMe.Collections.Ingridients()
      
      @fixture = {
        id: "1",
        comments_list: [{
            id: 1,
            text: "1"
          },
          {
            id: 2,
            text: "2"
          }],
        steps_list: [{
          id: 1,
          text: "Step 1"
        },
        {
          id: 2,
          text: "Step 2"
        }],
        ingridients_list: [{
          id: 1,
          name: "Ingridient 1",
          size: 100
        },
        {
          id: 2,
          name: "Ingridient 2",
          size: 200
        }]

      }
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "/api/recipes/#{@recipe.id}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@fixture)]);
      @response = @server.responses[0].response

    afterEach ->
      @server.restore()

    describe "fetch server data", ->
      beforeEach ->
        @recipe.fetch({async: false})

      it "make a correct request", ->
        expect(@server.requests.length).toEqual(1);
        expect(@server.requests[0].method).toEqual("GET");
        expect(@server.requests[0].url).toEqual("/api/recipes/#{@recipe.id}");

      describe "comments list", ->

        it "return not empty comments list", ->
          @server.respond()
          expect(@recipe.get("comments").length).toEqual(@fixture.comments_list.length)

        it "return correct text of first comment", ->
          @server.respond()
          expect(@recipe.get("comments").get(1).get("text")).toEqual("1")

      describe "steps list", ->

        it "return not empty steps list", ->
          @server.respond()
          expect(@recipe.get("steps").length).toEqual(@fixture.steps_list.length)

        it "return correct text of first step", ->
          @server.respond()
          expect(@recipe.get("steps").get(1).get("text")).toEqual("Step 1")

      describe "ingridients list", ->
        it "return not empty ingridients list", ->
          @server.respond()
          expect(@recipe.get("ingridients").length).toEqual(@fixture.ingridients_list.length)

        it "return correct name of first ingridient", ->
          @server.respond()
          expect(@recipe.get("ingridients").get(1).get("name")).toEqual("Ingridient 1")




