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
