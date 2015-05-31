describe "Feed", ->
  describe "#initialize", ->
    describe "params are set", ->
      it "have @user and @feed parameter", ->
        feed = new RecipeMe.Models.Feed({id: 1, feed: {id: 2}})
        expect(feed.user).toEqual(1)
        expect(feed.feed).toEqual({id: 2})

    describe "params are set", ->
      it "doesn't have parameters", ->
        feed = new RecipeMe.Models.Feed()
        expect(feed.user).toBeUndefined()
        expect(feed.feed).toBeUndefined()

  describe "#url", ->
    describe "@user and @feed are defined", ->
      it "return url for particular feed", ->
        feed = new RecipeMe.Models.Feed({id: 1, feed: 2})
        expect(feed.url()).toEqual("api/users/1/feeds/2")

    describe "@user defined, @feed is not", ->
      it "return url for feed list", ->
        feed = new RecipeMe.Models.Feed({id: 1})
        expect(feed.url()).toEqual("api/users/1/feeds")

    describe "@user and @feed aren't defined", ->
      it "return url for particular feed", ->
        feed = new RecipeMe.Models.Feed()
        expect(feed.url()).toEqual("api/users")

  describe "#parse", ->
    beforeEach ->
      @user = new RecipeMe.Models.User({id: 1})
      @feed = new RecipeMe.Models.Feed({id: @user.get('id'), feed: 1})
      @fixture = [
        {
          id: 1,
          user_id: 2,
          update_type: "create",
          update_id: 367,
          update_entity: "Recipe",
          update_entity_for: "Recipe",
          type: "RecipeUpdate"
        },
        {
          id: 1,
          user_id: 2,
          update_type: "create",
          update_id: 367,
          update_entity: "Comment",
          update_entity_for: "Comment",
          type: "CommentUpdate",
          recipe: new RecipeMe.Models.Recipe({id: 1})
        },
        {
          id: 1,
          user_id: 2,
          update_type: "create",
          update_id: 367,
          update_entity: "Vote",
          update_entity_for: "Recipe",
          type: "VoteUpdate"
        },
        {
          id: 1,
          user_id: 2,
          update_type: "create",
          update_id: 367,
          update_entity: "Vote",
          update_entity_for: "Comment",
          type: "VoteUpdate"
        }]
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "api/users/#{@user.get('id')}/feeds/#{@feed.get('id')}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@fixture[0])]);
      @response = @server.responses[0].response
      @feed.fetch({async: false})

    describe "request params", ->
      it "return correct request length", ->
        expect(@server.requests.length).toEqual(1);

      it "return correct request type", ->
        expect(@server.requests[0].method).toEqual("GET");

      it "return correct url", ->
        expect(@server.requests[0].url).toEqual("api/users/1/feeds/1");

    describe "parse data", ->
      beforeEach ->
        @server.respond()

      describe "create recipe event", ->

        it "return correct update_type of feed", ->
          expect(@feed.get("update_type")).toEqual("create")

        it "return correct update_entity type", ->
          expect(@feed.get("update_entity")).toEqual("Recipe")


