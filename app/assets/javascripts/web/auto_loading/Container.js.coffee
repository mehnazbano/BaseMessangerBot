MehnazApp.AutoLoading = {} unless MehnazApp.AutoLoading?

###
 =MehnazApp.AutoLoading.Container=
//
 This module handles the creation of instances for autoLoadingContainer
###
MehnazApp.AutoLoading.Container = (container) ->
  _url = null
  _container = null
  _afterContentLoadCallBackFunction = null
  _ajax_loader_image = $('#loading_image').clone()

  ###
    == //_init// ==
    Constructor for the class
  ###
  _init = (container) ->
    (_container = container)
    true

  ###
    == //_loadContainer// ==
     Makes an ajax request to load the container
  ###
  _loadContainer = ->
    _url = _container.attr("data-href")
    _ajax_loader_image.removeClass('hidden').addClass('loaderForContainer').attr('id', '')
    _ajax_loader_image.prependTo(_container)
    $.ajax(_url, success: _afterSuccess, dataType: 'json')

  ###
  == //_afterSuccess// ==
  Loads the data that comes back from server.
  Also replaces the container with an id of *content_count* with the value from json if present
  Fires the callback after the content loads
  ###
  _afterSuccess = (data) ->
    _container.html(data.content)

    _container.find('img.loaderForContainer').remove() # Remove any orphaned loading image


  ###
  Instance method that refreshes the content of the container

  //Parameters//
  * **afterContentLoadCallBackFunction** Callback to be executed after the content loads
  ###
  @refresh = (afterContentLoadCallBackFunction = null) ->
    console.log('*****@@@@kkkk')
    _afterContentLoadCallBackFunction = afterContentLoadCallBackFunction
    _loadContainer()

  _init(container)
  this
###
 == Example Usage ==

 _commentContainer = new AutoLoading.Container

 _commentContainer.refresh

###