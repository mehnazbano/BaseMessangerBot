MehnazApp.AutoLoading = {} unless MehnazApp.AutoLoading?

###
  =MehnazApp.AutoLoading.Containers=
  // Autoloads the various containers with content after the page loads
###
MehnazApp.AutoLoading.Containers = do ->
  _containers = null

  ###
    == //_init// ==
    loads the container with content
  ###
  _init = ->
    _containers.each ->
      container = $(this)
      autoLoadingContainer = new MehnazApp.AutoLoading.Container(container)
      autoLoadingContainer.refresh()

  ###
    == MehnazApp.AutoLoading.Containers.init() ==
    Should be called during page load
  ###
  init: ->
    _containers = $(".auto_loading_container")
    if _containers.length isnt 0 then _init()