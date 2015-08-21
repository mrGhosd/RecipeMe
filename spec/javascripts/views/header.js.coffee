describe "HeaderView", ->
  beforeEach ->
    @view = new RecipeMe.Views.HeaderView()
    @view.render()

  describe "initialization", ->
    it "it should create element", ->
      expect(@view.el.nodeName).toEqual("DIV")

    it "produces the correct HTML", ->
      expect(@view.template()).toEqual(JST['application/header']())

  describe "behaviour", ->
    beforeEach ->
      $("input.login-window").click()

    it "show authorization window", ->
      expect($('body')).toHaveClass("modal-open")

    it "show sign in li element in window", ->
      expect($('li.sign_in')).toHaveClass('active')
      expect($('li.sign_up')).not.toHaveClass('active')

