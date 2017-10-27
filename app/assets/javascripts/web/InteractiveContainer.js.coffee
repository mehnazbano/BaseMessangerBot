# ##Knome.InteractiveContainer
#This is responsible to show the textFeedback (Comments, Answers etc.)
MehnazApp.InteractiveContainer = do ->
  _container = null
  _autoLoadingContainer = null

  # ----------------

  # ###_init
  #Calls loadContainer on each of the auto loading container
  _init = ->
    _autoLoadingContainer = new MehnazApp.AutoLoading.Container(_container)
    console.log('***')
    console.log('*****')
    if (_container.attr("auto-load") is "true")
      # Refresh the container, Scroll to to the element if required
      console.log('*****@@@@')
      _autoLoadingContainer.refresh(_refreshCallBack)

  _refreshCallBack = ->
    MehnazApp.Locate.init(_container )
    #Knome.Template.Like.displayLikes()

  # ----------------

  # ###Knome.InteractiveContainer.init
  #Inits the autoLoading Containers
  init: ->
    _container = $(".interactive_container, .text_feedback_container")
    console.log('gggg-------')
    console.log(_container)
    if _container.length isnt 0
      # Special case for comments permalinking
      #   When there is a comment permalink we only load the actual comment, its ancestors and its descendents
      commentContainer = $(".interactive_container.knome-kso-comments")
      if commentContainer.length isnt 0 && $("#comment_path").length isnt 0
        commentContainer.attr("data-href", $("#comment_path").val())

      _init()


  # ----------------

  # ###Knome.InteractiveContainer.refresh
  #Refreshes the content of the container
  #
  # 1. **afterContentLoadCallBackFunction** :: Callback to be executed after the content loads
  refresh: () ->
    _autoLoadingContainer.refresh(_refreshCallBack)

  # ----------------

  # ###Knome.InteractiveContainer.setDataHref ==
  #Sets the url for the container
  #
  # 1. **url** The url to be set
  setDataHref: (url) ->
    _container.attr("data-href", url)

  # ----------------

  # ###Knome.InteractiveContainer.getContainer
  # Returns the container
  getContainer:  ->
    _container
