describe "Category", ->
  describe "basic attributes setting", ->
    it "set title", ->
      @category = new RecipeMe.Models.Category({title: "Title"})
      expect(@category.get("title")).toEqual("Title")

    it "set title", ->
      @category = new RecipeMe.Models.Category({description: "Description"})
      expect(@category.get("description")).toEqual("Description")

  describe "#initialize", ->
    it "has id if param is send", ->
      @category = new RecipeMe.Models.Category({id: 1})
      expect(@category.category_id).toEqual(1)

    it "has an image if params is not send", ->
      @category = new RecipeMe.Models.Category()
      expect(@category.get("image")).not.toBeUndefined()

  describe "#parse", ->
    beforeEach ->
      @category = new RecipeMe.Models.Category({id: 1})
      @fixture = {
        id: 1,
        title: "Author",
        description: "Text",
        recipes: [
          {
            id: 1,
            title: "First"
          },
          {
            id: 2,
            title: "Second"
          }
        ]
      }
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "api/categories/#{@category.get('id')}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@fixture)]);
      @response = @server.responses[0].response
      @category.fetch({async: false})

    describe "request params", ->

      it "return correct request length", ->
        expect(@server.requests.length).toEqual(@fixture.recipes.length);

      it "return correct request type", ->
        expect(@server.requests[0].method).toEqual("GET");

      it "return correct url", ->
        expect(@server.requests[0].url).toEqual("api/categories/#{@category.get("id")}");

    describe "fetch data", ->

      it "return correct description of category", ->
        @server.respond()
        expect(@category.get("description")).toEqual("Text")

      it "return correct title of category", ->
        @server.respond()
        expect(@category.get("title")).toEqual("Author")

  describe "#save", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "with invalid attributes", ->
      beforeEach ->
        @category = new RecipeMe.Models.Recipe({title: ""})
        @server.respondWith("POST", "/api/categories",
          [403, { "Content-Type": "application/json" },
           JSON.stringify({title: ['cant be blank'] })]);
        @category.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "still mark recipe as a new", ->
        expect(@category.isNew()).toBe(true)

      it "define a recipe", ->
        expect(@category).toBeDefined()

      it "has 403 status", ->
        expect(@responses[0]).toBe(403)

      it "doesn't save recipe if title field is empty", ->
        expect(JSON.parse(@responses[2]).title[0]).toBe("cant be blank")

    describe "with valid attributes", ->
      beforeEach ->
        @category = new RecipeMe.Models.Recipe({title: "Title", description: "Desc"})
        @server.respondWith("POST", "/api/categories",
          [200, { "Content-Type": "application/json" }, JSON.stringify(@category)]);
        @category.save()
        @server.respond()
        @responses = @server.responses[0].response

      it "has 200 status", ->
        expect(@responses[0]).toBe(200)

      it "return recipes attributes object", ->
        expect(JSON.parse(@responses[2])).toEqual(@category.attributes)

