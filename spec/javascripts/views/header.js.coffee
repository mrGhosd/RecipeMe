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
    describe "sign in button click", ->
      beforeEach ->
        $("input.login-window").click()

      it "show authorization window", ->
        expect($('body')).toHaveClass("modal-open")

      it "show sign in li element in window", ->
        expect($('li.sign_in')).toHaveClass('active')
        expect($('li.sign_up')).not.toHaveClass('active')

    describe "sign up button click", ->
      beforeEach ->
        $("input.registration-window").click()

      it "show registration window", ->
        expect($('body')).toHaveClass("modal-open")

      it "show sign up li element in window", ->
        expect($('li.sign_in')).not.toHaveClass('active')
        expect($('li.sign_up')).toHaveClass('active')

    describe "navigation menu", ->
      beforeEach ->
        @navigation = new RecipeMe.Views.NavigationView()
        @navigation.render()

      describe "when menu is closed", ->
        beforeEach ->
          $("a.left-menu-opener").click()

        it "shows a navigation menu", ->
          expect($("#navigationMenu")).toBeVisible()

      describe "when menu is opened", ->
        beforeEach (done) ->
          $(@navigation.el).show()
          $(@navigation.el).width(300)
          done()
#          $("div.menu-item").click()
#          $("div.menu-item").click()
#          @view.toggleLeftMenu()
#          $("#navigationMenu").width == 300
#          $(@navigation.el).width = 300
#          @view.toggleLeftMenu()

        it "hides a navigation menu", ->
          expect($(@navigation.el)).not.toBeVisible()


