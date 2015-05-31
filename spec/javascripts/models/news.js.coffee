describe "News", ->
  describe "#initialize", ->
    describe "params are empty", ->
      it "should have and empty image", ->
        news = new RecipeMe.Models.New()
        expect(news.get("image")).not.toBeUndefined()

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @news = new RecipeMe.Models.New({title: ""})
        @server.respondWith("POST", "/api/categories",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({title: ['cant be blank'] })]);
        @news.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@news.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@news).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).title[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @news = new RecipeMe.Models.New({title: "Title", text: "Desc"})
        @server.respondWith("POST", "/api/categories",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@news)]);
        @news.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@news.attributes)