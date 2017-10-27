MehnazApp.Form = {} unless MehnazApp.Form?


MehnazApp.Form.Common = do ->

  init: ->
    if $('#simple-menu').length > 0
      $('#simple-menu').sidr()