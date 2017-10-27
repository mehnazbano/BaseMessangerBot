MehnazApp.AutoLoading = {} unless MehnazApp.AutoLoading?

# ##Knome.LoadMore
# This is responsidble to init the loadMore link
MehnazApp.AutoLoading.LoadMore = do ->
  _loadMoreLink = null
  LOADING_TEXT = 'Loading'

  # ### _init
  # Inits the load more link
  #
  _init = ->
    console.log('%%%%%%%')
    # Make sure to set the request's response type to be html
    $(document).on MehnazApp.Common.Ajax.events().success, ".js_loadmore-trigger", _loadMoreSuccess
    $(document).on MehnazApp.Common.Ajax.events().beforeSend, ".js_loadmore-trigger", _loadMoreBeforeSend

  # ### _loadMoreBeforeSend
  #
  # When user clicks on the `more` button on any listing pages, before sending the ajax request to the server
  # this function will show the ajax loading gif to indicate that the request is sent and is beeing processed.
  #
  # **event** - Event from the action
  #
  _loadMoreBeforeSend = (event) ->
    loadingImage = $('<a>').append($('#loading_image').clone().removeClass('hidden ajaxLoaderSingle').addClass('inlineText').attr('id', '')).html()
    text = $("<span>",
      class: "muted inlineText"
      ).text(LOADING_TEXT)
    $(this).hide().parent().append(loadingImage).append(text)

  # ### _loadMoreSuccess
  #
  # Appends the data coming from response, to the interactive_container.
  #
  # **event** - Event from the action.
  # **data** - JSON object from the ajax response.
  #
  _loadMoreSuccess = (event, data) ->
    # Remove the link as the result will have a new pagination link
    target = $(event.target)
    container = target.closest(".interactive_container")
    container = target.closest(".ajax_container") if container.length is 0
    container = target.closest(".carrot-container") if container.length is 0
    container = target.closest(".knome-timeline-list") if container.length is 0
    container = target.closest('.knome-people-listing') if container.length is 0
    container = target.closest('.knome-wikis-list')  if container.length is 0
    container = target.closest('.sme-people-listing') if container.length is 0
    container = target.closest('.webinar-participant-listing') if container.length is 0
    container = target.closest('.webinar-listing') if container.length is 0
    container = target.closest('.js_conversation_list') unless container.length
    container = target.closest('.js_messages_list') unless container.length
    container = $('tbody.js_media_list_container')  if container.length is 0
    container = $('ul.js_media_list_container')  if container.length is 0
    container = target.closest('.js_participants') unless container.length
    container = target.closest('.js_form_template_listing')  if container.length is 0
    container = target.closest('.js_form_user_listing')  if container.length is 0
    topContainer = container
    # As we have 2 load mores in the same page, in live chat page,
    # We are handling it differently.
    console.log('container------')
    console.log(container)
    if container.length is 0
      container = target.closest(".knome-live-tracker-list")
      # We are going to remove the More button associated with this container alone
      $(".knome-live-tracker-list li.knome-kso-comment-pagination").remove()
      content = $(data.content).html()
      container.find('#live_chat_activity_ticker_container').append(content)

      # Handle load more for Conversation Messages
      container = target.closest("#js_message_container")
      if container.length isnt 0
        $('li.knome-kso-comment-pagination', container).remove()
        container.prepend(data.content)
        # Rename the pagination "More.." link to "Prev.."
        otherMessagesLoadMore = $('.js_message_others_container').find('.js_loadmore-trigger')
        otherMessagesLoadMore.attr('href', "#{otherMessagesLoadMore.attr('href')}&type=actionable")
        $('.js_loadmore-trigger', container).html('Previous')
        # Remove the pagination link if there are no more items to load
        loadMoreLink = $('.js_loadmore', container)
        loadMoreLink.parent().remove() if loadMoreLink.html() is ""
      container = target.closest("#js_conversation_container")
      if container.length isnt 0
        $('li.knome-kso-comment-pagination', container).remove()
        container.append(data.content)
      container = target.closest("#js_message_others_container")
      if container.length isnt 0
        $('li.knome-kso-comment-pagination', container).remove()
        container.append(data.content)
    else
      console.log('elseee coming')
      if container.parents('.knome-ticker-list-comment').length isnt 0
        # We are going to remove the More button associated with this container alone
        $(".knome-ticker-list-comment li.knome-kso-comment-pagination").remove()
      else if container.find('#users_who_interacted_with').length isnt 0
        container.find('#user_pagination').html(data.pagination_html)
        container = container.find('#users_who_interacted_with')
      else if container.find('#sme_list_in_community').length isnt 0
        container.find('#sme_pagination').html(data.pagination_html)
        container = container.find('#sme_list_in_community')
      else if container.find('#webinar_participants').length isnt 0
        container.find('#webinar_participants_pagination').html(data.pagination_html)
        container = container.find('#webinar_participants')
      else if container.find('#webinar_list').length isnt 0
        container.find('#webinar_pagination').html(data.pagination_html)
        container = container.find('#webinar_list')
      else
        $(".js_loadmore").remove()
      # Check for Json and use content, else, simply pass daat along
      if $('.js_your_wikis', container).length
        $('.js_your_wikis', container).append(data.content)
        $('.js_wiki_pagination', container).html(data.pagination_html)
      else if $('.js_media_list_container').length isnt 0
        container.append(data.content)
        $('.js_media_list_pagination').html(data.pagination_html)
      else
        content = data
        content = data.content if typeof data is 'object'
        container.append content
    _filterDuplicateItems(topContainer)

    if data.uncached_content
      Knome.Template.Like.displayLikes(data.uncached_content)

    Knome.AttachmentRenderer.AudioVideo.init()

    # Run Truncate and Autohide for kicks
    Knome.Truncate.init()

  # ### _filterDuplicateItems
  # Removing items with duplicate ids in any list on click of
  # Load more.
  #
  _filterDuplicateItems = (container) ->
    itemsCount = {}
    $('li', container).each ->
      if @id.length
        if itemsCount[@id]?
          $(@).remove()
        else
          itemsCount[@id] = 1

  init: ->
    _loadMoreLink = $(".js_loadmore-trigger")
    _init()