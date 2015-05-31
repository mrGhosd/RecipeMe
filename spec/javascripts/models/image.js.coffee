describe "Image", ->
  describe "#initialize", ->
    describe "options step_id exists", ->
      it "return image step_id", ->
        image = new RecipeMe.Models.Image({step_id: 1})
        expect(image.step_id).toEqual(1)

    describe "step_id doesn't exists", ->
      it "return undefined image", ->
        image = new RecipeMe.Models.Image()
        expect(image.step_id).toBeUndefined()

#  describe "#uploadImage", ->
#    beforeEach ->
#      @server = sinon.fakeServer.create()
#      @image = new RecipeMe.Models.Image({id: 1})
#      @server.respondWith("POST", "/api/images",
#        [200, { "Content-Type": "application/json" }, JSON.stringify({id: 1})]);
#      @image.uploadImage({imageable_type: "Recipe", imageable_id: 1})
#      @server.respond()
#      console.log @server.responses[0].response
#      console.log @server.requests.length
#      @responses = @server.responses[0].response
#
#    afterEach ->
#      @server.restore()
#
##    it "return correct request length", ->
##      expect(@server.requests.length).toEqual(1);
#
##    it "return correct request type", ->
##      expect(@server.requests[0].method).toEqual("POST");
##
#    it "return correct url", ->
#      expect(@server.requests[0].url).toEqual("/api/images");
#
##    it "upload image to server", ->
