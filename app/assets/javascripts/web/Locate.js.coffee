# Locates KSO elements via a permalink
MehnazApp.Locate = do ->
  _container = null
  _locateElement = null
  _paginationTrigger = null
  _elementId = ""
  _scrollOffset = 150
  _scrollSpeed = 1000
  _highlightDuration = 1000
  _locateCallback = null


  # Locates the Element
  _findElement =  ->
    # Seek the element within the container
    elementFound = $(_elementId)
    if elementFound.length is 1
      Knome.Common.FlashNotification.showFlash({"header" : "", "content" : I18n.t('javascripts.common.found_it')}, "message")
      _scrollToElement(elementFound)
    else
      Knome.Common.FlashNotification.showFlash({"header" : "", "content" : I18n.t('javascripts.common.still_looking')}, "notice")
      _paginationTrigger = $('a.next', _container)
      # The element is probably on another page so paginate
      if _paginationTrigger.length isnt 0
        # Latch onto the pagination
        _paginationTrigger.bind 'ajax:success', (e) ->
          # Call locate after the pagination completes and the DOM loads
          clearTimeout(_locateCallback) if _locateCallback isnt null
          _locateCallback = setTimeout( ->
              MehnazApp.Locate.init(_container)
            , 1000)
        # Paginate
        _scrollToElement _paginationTrigger
      else
        MehnazApp.Locate.init(_container)

  # Scroll to to the element if required
  _scrollToElement = (element) ->
    if element isnt ""
      $('html, body').animate
        scrollTop: element.offset().top - _scrollOffset,
        _scrollSpeed,
        "linear",
        -> $(_elementId).effect('highlight', _highlightDuration)
      # Try this as this would be the expected behaviour
      element.click()

  ###
    == _scrollToElementWithinContainer ==

    Scrolls to elements within a jScrollPane
  ###
  _scrollToElementWithinContainer = (container, element) ->
    container.stop().scrollTo $(element), 1000
    # Try this as this would be the expected behaviour
    element.click()

  ###
    == elementLocateWithinContainer ==

    Finds elements present within any container

    * container - Can be any container
    * elementQuery - The jQuery string used - Eg "#kso_5"

  ###
  elementLocateWithinContainer : (container, elementQuery) ->
    element = $(elementQuery)
    if element isnt null and element.length isnt 0
      # We have found the element. Lets find, highlight and open it
      Knome.Common.FlashNotification.showFlash({"header" : "", "content" : I18n.t('javascripts.common.found_it')}, "message")
      _scrollToElementWithinContainer container, element
    else
      paginationTrigger = $('a.next', container)
      # The element is probably on another page so paginate
      if paginationTrigger.length isnt 0
        Knome.Common.FlashNotification.showFlash({"header" : "", "content" : I18n.t('javascripts.common.still_looking')}, "notice")
        # Latch onto the pagination
        paginationTrigger.bind 'ajax:success', (e) ->
          # Call locate after the pagination completes and the DOM loads
          clearTimeout(_locateCallback) if _locateCallback isnt null
          _locateCallback = setTimeout( ->
              MehnazApp.Locate.elementLocateWithinContainer(container, elementQuery)
            , 1000)
        # Paginate
        _scrollToElementWithinContainer container, paginationTrigger

  init: (container) ->
    _container = container
    _locateElement = $('#locate_element')
    _paginationTrigger = null
    if _locateElement.length isnt 0 and _container.length isnt 0
      _elementId = '#' + _locateElement.val()
      # Begin the hunt
      _findElement()