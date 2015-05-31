describe "User", ->
  describe "#url", ->
    describe "params.id existed", ->
      it "should return url for particular user", ->
        user = new RecipeMe.Models.User({id: 1})
        expect(user.url()).toEqual("/api/users/1")

    describe "params.id doesn't exist", ->
      it "should common url for all users", ->
        user = new RecipeMe.Models.User()
        expect(user.url()).toEqual("/api/users")

  describe "#isAdmin", ->
    describe "user has role 'admin'", ->
      it "return true", ->
        user = new RecipeMe.Models.User({role: 'admin'})
        expect(user.isAdmin()).toBeTruthy()

    describe "user hasn't role 'admin'", ->
      it "return false", ->
        user = new RecipeMe.Models.User({role: 'user'})
        expect(user.isAdmin()).toBeFalsy()

  describe "#isResourceOwner", ->
    describe "user is resource owner", ->
      it "return true", ->
        user = new RecipeMe.Models.User({id: 1})
        recipe = new RecipeMe.Models.Recipe({user_id: user.get('id')})
        expect(user.isResourceOwner(recipe)).toBeTruthy()

    describe "user is isn't resource owner", ->
      it "return false", ->
        user = new RecipeMe.Models.User({id: 1})
        recipe = new RecipeMe.Models.Recipe({user_id: 2})
        expect(user.isResourceOwner(recipe)).toBeFalsy()

  describe "#parse", ->
    beforeEach ->
      @user = new RecipeMe.Models.User({id: 1})
      @fixture = {
        id: "1",
        followers_list: [{
          id: 1,
          name: "1"
        },
          {
            id: 2,
            name: "2"
          }],
        following_list: [{
          id: 1,
          name: "3"
        },
          {
            id: 2,
            name: "4"
          }]
      }
      @server = sinon.fakeServer.create()
      @server.respondWith("GET", "/api/users/#{@user.id}",
        [200, { "Content-Type": "application/json" }, JSON.stringify(@fixture)]);
      @response = @server.responses[0].response

    afterEach ->
      @server.restore()

    describe "fetch server data", ->
      beforeEach ->
        @user.fetch({async: false})

      it "request has a correct length", ->
        expect(@server.requests.length).toEqual(3);
      it "request has a correct request type", ->
        expect(@server.requests[0].method).toEqual("GET");
      it "request has a correct url", ->
        expect(@server.requests[0].url).toEqual("/api/users/#{@user.get('id')}");

      describe "followers list", ->

        it "return not empty followers list", ->
          @server.respond()
          expect(@user.get("followers_list").length).toEqual(@fixture.followers_list.length)

        it "return correct name of first follower user", ->
          @server.respond()
          expect(@user.get("followers_list").get(1).get("name")).toEqual("1")

      describe "following list", ->

        it "return not empty following list", ->
          @server.respond()
          expect(@user.get("following_list").length).toEqual(@fixture.following_list.length)

        it "return correct name of first following user", ->
          @server.respond()
          expect(@user.get("following_list").get(1).get("name")).toEqual("3")




