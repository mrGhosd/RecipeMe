describe "Comment", ->
  describe "basic attributes", ->
    it "should return text", ->
      comment = new RecipeMe.Models.Comment({text: "Text"})
      expect(comment.get("text")).toEqual("Text")

  describe "#initialize", ->
    describe "parameter is set", ->
      it "recipe param is setted", ->
        @comment = new RecipeMe.Models.Comment({recipe: 1})
        expect(@comment.recipe).toEqual(1)

    describe "parameter is null", ->
      it "recipe param is 0", ->
        @comment = new RecipeMe.Models.Comment({id: 2})
        expect(@comment.recipe).toBeUndefined()

    describe "user is set", ->
      it "create User model instance", ->
        @comment = new RecipeMe.Models.Comment({id: 2, user: {id: 1}})
        expect(@comment.get('user') instanceof RecipeMe.Models.User).toBe(true)

    describe "user isn't set", ->
      it "doesn't create User model instance", ->
        @comment = new RecipeMe.Models.Comment({id: 2})
        expect(@comment.user instanceof RecipeMe.Models.User).toBe(false)

  describe "#url", ->
    describe "parameters was sended", ->
      it "return url for particular comment", ->
        @comment = new RecipeMe.Models.Comment({recipe: 1, id: 2})
        expect(@comment.url()).toEqual("api/recipes/1/comments/2")

    describe "parameters wasn't sended", ->
      it "return url for comments creation", ->
        @comment = new RecipeMe.Models.Comment({recipe: 1})
        expect(@comment.url()).toEqual("api/recipes/1/comments")

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({id: 1})
        @comment = new RecipeMe.Models.Comment({recipe: @recipe.get('id'), text: "Text"})
        @server.respondWith("POST", "/api/recipes/#{@recipe.get('id')}/comments",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({title: ['cant be blank'] })]);
        @comment.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@comment.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@comment).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).title[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @recipe = new RecipeMe.Models.Recipe({id: 1})
        @comment = new RecipeMe.Models.Comment({recipe: @recipe.get('id'), text: "Text"})
        @server.respondWith("POST", "/api/recipes",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@comment)]);
        @comment.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@comment.attributes)
