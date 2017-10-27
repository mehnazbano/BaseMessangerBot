MehnazApp.AutoLoading = {} unless MehnazApp.AutoLoading?

# ##Knome.AjaxContainer
# This behaves like a customised InteractiveContainer for Modals
MehnazApp.AutoLoading.AjaxContainer = do ->
  _container = null
  _url = null
  _ajax_loader_image = $('#loading_image').clone()
  _clickedLink = null
  _communityContainer = null
  _locationContainer = null


  # ### _loadContainer
  # Makes an ajax request to load the container
  _loadContainer = ->
    $('.modalTitle').html("")
    _ajax_loader_image.removeClass('hidden').addClass('remove').attr('id', '')
    _container.empty().append(_ajax_loader_image)
    $("#user_pagination").html("")
    $('#sme_pagination').html('')
    $('#webinar_participants_pagination').html('')
    $('#webinar_pagination').html('')
    $.ajax(_url, success: _afterSuccess, dataType: 'json')

  # ------------------

  _loadCommunityContainer = ->
    $('#user_pagination').html('')
    $('#sme_pagination').html('')
    $('#webinar_participants_pagination').html('')
    $('#webinar_pagination').html('')
    $('.modalTitle').hide()
    $('#users_who_interacted_with_community').hide()
    $('#users_who_interacted_with_community').closest('.knome-modal-list').addClass('loader')
    $.ajax(_url, success: _afterCommunitySuccess, dataType: 'json')

  # ------------------

  # ### _loadLocationContainer
  # Loads into the container
  _loadLocationContainer = ->
    # Reset the modal Title
    $('.modalTitle').html("")
    $('#_loading_image_view_locations').show()
    _locationContainer.empty()
    $('#_view_locations_list').html("")
    # Reset the user pagination
    $("#user_pagination").html("")
    $('#sme_pagination').html('')
    $('#webinar_participants_pagination').html('')
    $('#webinar_pagination').html('')
    $.ajax(_url, success: _afterLocationSuccess, dataType: 'json')

  # ------------------

  # ### _afterSuccess
  # Loads the data that comes back from server.
  #
  #  1. **data** :: A json object returned form ajax request.
  _afterSuccess = (data) ->
    _container.html(data.content) if (data.content isnt "")
    $('.modalTitle').html(data.content_title) if (data.content_title isnt "")
    $("#user_pagination").html(data.pagination_html) if (data.pagination_html isnt "")
    $('#sme_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_participants_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#user_page_info').html(data.page_info) if (data.pagination isnt "")
    $('img.remove').remove() # Remove any orphaned loading image
    # Hack for communities
    $('.js_community_checkbox', _container).remove()

  # ------------------

  # ### _afterLocationSuccess
  # Handles the data after the loaction details arrive form the server.
  #
  #  1. **data** :: A json object returned form ajax request.
  _afterLocationSuccess = (data) ->
    $('#_view_locations_list').html(data.content) if (data.content isnt "")
    $('.modalTitle').html(data.content_title) if (data.content_title isnt "")
    $('#_loading_image_view_locations').hide()
    $("#user_pagination").html(data.pagination_html) if (data.pagination_html isnt "")
    $('#sme_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_participants_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_pagination').html(data.pagination_html) if (data.pagination_html isnt '')

  # ------------------

  # ### _afterCommunitySuccess
  # Handles the data after the community details arrive form the server.
  #
  #  1. **data** :: A json object returned form ajax request.
  _afterCommunitySuccess = (data) ->
    $('#users_who_interacted_with_community').html(data.content).show() if (data.content isnt "")
    $('.modalTitle').html(data.content_title).show() if (data.content_title isnt "")
    $("#user_pagination").html(data.pagination_html) if (data.pagination_html isnt "")
    $('#sme_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_participants_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#user_page_info').html(data.page_info) if (data.pagination isnt "")
    # Removing the loader image on ajax success.
    $('#users_who_interacted_with_community').closest('knome-modal-list').removeClass('loader')
    $('img.remove').remove() # Remove any orphaned loading image

  # ------------------

  # ### _handleClick
  # Handles the click event on sort link
  # Refreshes the AjaxContainer with the content from the result
  #
  #  1. **event** :: A event object of that action
  _handleClick = (event) ->
    _clickedLink = $(this)
    $(".js_modal_header").show()
    _url = _clickedLink.attr('data-href')
    _container = $('#'+_clickedLink.attr('container'))

    # Save the URL incase the container is also an autobrowse
    if _container.hasClass("autobrowse")
      _container.attr("data-href", _url)
      Knome.Autobrowse.init()
    if _container.hasClass('autobrowse-store')
      $('[autobrowse-connector='+_container.attr('id')+']').attr("data-href", _url)
      Knome.Autobrowse.init()

    _loadContainer()

  # ------------------

  # ### _handleCommunityClick
  # Handles the click event on community click
  # Refreshes the AjaxContainer with the content from the result
  #
  #  1. **event** :: A event object of that action
  _handleCommunityClick = (event) ->
    _clickedLink = $(this)
    _url = _clickedLink.data('href')
    _loadCommunityContainer()

  # ------------------

  # ### _handleLocationClick
  # Handles the click event on location click
  # Refreshes the AjaxContainer with the content from the result
  #
  #  1. **event** :: A event object of that action
  _handleLocationClick = (event) ->
    _clickedLink = $(this)
    $("#knome-location-header").show()
    _url = _clickedLink.attr('data-href')
    _locationContainer = $('#'+_clickedLink.attr('_locationContainer'))
    _loadLocationContainer()

  # ------------------

  # ### _paginate
  # Handles the pagination for the loaded content
  #
  #  1. **data** :: A json object returned form ajax request.
  _paginate = (data) ->
    _container.empty().append(_ajax_loader_image)
    _populateContainerContent(jQuery.parseJSON(data))

  # ------------------

  # ### _populateContainerContent
  # Populates the conten in the container.
  #
  #  1. **data** :: A json object returned form ajax request.
  _populateContainerContent = (data) ->
    template_data = jQuery.parseJSON(data.data)
    _container.html(data.content) if (data.content isnt "")
    $("#user_pagination").html(data.pagination_html) if (data.pagination_html isnt "")
    $('#sme_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_participants_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#webinar_pagination').html(data.pagination_html) if (data.pagination_html isnt '')
    $('#user_page_info').html(data.page_info) if (data.pagination isnt "")

    # The following code line was the reason why links which were displayed
    # in the modal dialog to display the followers, likers, etc were not
    # opening the corresponding pages.
    #
    # TODO: The following commented code has to be removed after 2 weeks
    #       of deployment if there is no problem faced.
    #
    # event.preventDefault()

  # ------------------

  # ##Knome.AjaxContainer.init
  # Inits the Ajax Containers
  # ####Usage Examples
  #     Knome.AjaxContainer.init(elementtobeupdated, urltobeconsumed)
  #
  #  1. **elementtobeupdated** :: A jquery or Dom object.
  #  2. **urltobeconsumed**    :: The URL to get the ajax content.
  init: ->
    _container = $(".ajax_container")
    #_container.live('click', _handleClick)
    #$('#pagination_container .gallary-pagination-links').live('ajax:success', (event, data) -> _paginate(data) )
    _communityContainer = $(".ajax_container_community")
    #_communityContainer.live('click', _handleCommunityClick)
    _locationContainer = $(".ajax_container_location")
    #_locationContainer.live('click', _handleLocationClick)

  # ------------------

  # ##Knome.AjaxContainer.getContainer
  # Returns the container
  # ####Usage Examples
  #     Knome.AjaxContainer.getContainer()
  # **returns** :: jquery or Dom object
  getContainer:  ->
    _container