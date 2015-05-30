describe "Callbacks", ->
  describe "basic fields", ->
    it "should retrun a author, which was setted", ->
      callback = new RecipeMe.Models.Callback({author: "Author"})
      expect(callback.get("author")).toEqual("Author")

    it "should retrun text", ->
      callback = new RecipeMe.Models.Callback({text: "Text"})
      expect(callback.get("text")).toEqual("Text")

  describe "#fetch", ->
    beforeEach ->
      @callback = new RecipeMe.Models.Callback({id: 1})
      @fixture = {
        id: 1,
        author: "Author",
        text: "Text"
      }
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "api/callbacks/#{@callback.get('id')}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@fixture)]);
      @response = @server.responses[0].response
      @callback.fetch({async: false})

    afterEach ->
      @server.restore()

    describe "request params", ->

      it "return correct request length", ->
        expect(@server.requests.length).toEqual(1);

      it "return correct request type", ->
        expect(@server.requests[0].method).toEqual("GET");

      it "return correct url", ->
        expect(@server.requests[0].url).toEqual("api/callbacks/#{@callback.get("id")}");

    describe "fetch data", ->
#      beforeEach: ->
#        @callback.fetch({async: false})

      it "return correct text of callback", ->
        @server.respond()
        expect(@callback.get("text")).toEqual("Text")

      it "return correct author name of callback", ->
        @server.respond()
        expect(@callback.get("author")).toEqual("Author")
