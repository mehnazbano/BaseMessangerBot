MehnazApp.Common = {} unless MehnazApp.Common?

###
  =MehnazApp.Common.Ajax=
  This module is a Utility module handles the global level ajax options.
###
MehnazApp.Common.Ajax = do ->
  STATUS = {timeout: 'timeout', error: 'error', abort: 'abort', unauthorized: "Unauthorized", service_unavailable: "Service Unavailable"}
  TIMEOUT = 30000 # 30sec(30000)

  ###
    == //_beforeRemoteLinkRequestSent// ==
    Disables the link if the link is enabled.
    Prevents further action on the link if the link is already disabled
    //Parameters//
    * **event** the event object
  ###
  _beforeRemoteLinkRequestSent = (event) ->
    link = $(event.target)
    if (link.data("disabled") is "disabled")
      return false
    else
      link.data("disabled", "disabled")

  ###
    == //_disableLinkIfEnabled// ==
    Enables the link
    //Parameters//
    * **event** the event object
  ###
  _enableLink = (event) ->
    link = $(event.target)
    link.data("disabled", "")

  ###
    == //_showTimeoutError// ==
    Shows request timeout error message on normal ajax request.
    We show different error message, if it is while saving section.
    //Parameters//
    * **xhr** the xhr object
  ###
  _showTimeoutError = (xhr) ->
    if xhr.isSectionSave
      MehnazApp.Common.Ajax.showError(I18n.t 'javascripts.notice.error_while_saving_section')
    else
      MehnazApp.Common.Ajax.showError(MehnazApp.config().error.timeout)

  ###
    == MehnazApp.Common.Ajax.evnets ==
    Returns the various event object as defined in rails.js
    //Returns//
    * **event** An associative array of various events
  ###
  events: ->
    {beforeSend: "ajax:beforeSend", success: "ajax:success", error: "ajax:error", complete: "ajax:complete"}

  ###
   == MehnazApp.Common.Ajax.setRequestHeaderToAcceptHTMLResponse ==
   sets the request's header to accept HTML response

   //Parameters//
   * **event** The event object
   * **xhr** The XmlHTTPRequest object
   * **settings** The Ajax request's setting object
  ###
  setRequestHeaderToAcceptHTMLResponse: (event, xhr, settings) ->
    xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.html)

  ###
    == MehnazApp.Common.Ajax.setup ==
   Sets the prerequisite for Ajax with various options
   Also sets up event handlers on remote links so that they are disabled after
    they are clicked and enabled after receiving a response
  ###
  setup: ->
    $.ajaxSetup({
      timeout: TIMEOUT,
      statusCode: {
        400: (data) -> # For Bad Reqeust
          MehnazApp.Common.Ajax.showError(data.responseText, "warning", "")
        401: (data) ->  # For not authenticated users
          MehnazApp.Common.Ajax.showError(MehnazApp.config().error.loggedOutAgainLoginMessage, "warning")
        302: (data) ->  # For not authenticated users
          MehnazApp.Common.Ajax.showError(MehnazApp.config().error.loggedOutAgainLoginMessage, "warning")
        403: (data) ->  # For not authorized users
          message = null
          if !!data.responseText
            message = data.responseText
          else
            message = MehnazApp.config().error.unauthorized
          MehnazApp.Common.Ajax.showError(message, "warning")
        404: (data) ->
          MehnazApp.Common.Ajax.showError("page not found", "warning")
        500: (data) -> # For server Error
          MehnazApp.Common.Ajax.showError(MehnazApp.config().error.genericError)
        200: (data) -> # For success notification
          if data.notice?
            MehnazApp.Common.FlashNotification.showFlash({"header" : '', "content" :  data.notice}, "message")
      }
    })

    $(document).ajaxStart ->
      $('.headerSplashStrip').removeClass('loaded')

    $(document).ajaxStop ->
      $('.headerSplashStrip').addClass('loaded')
      window.prettyPrint()

    $(document).ajaxError (e, xhr, settings, exception) ->
      # An error has occurred. Remove all orphaned loader images. No false hopes.
      $('img.remove').remove()
      switch (exception)
        when STATUS.timeout then _showTimeoutError(xhr)
        when STATUS.error then MehnazApp.Common.Ajax.showError(MehnazApp.config().error.genericError)
        #when STATUS.unauthorized then MehnazApp.Common.Ajax.showError(MehnazApp.config().error.unauthorized, "warning")
        when STATUS.service_unavailable then MehnazApp.Common.Ajax.showError(xhr.responseText)
        # This is a case when there is no error response but still it invokes this
        # callback as the page lost focus when an ajax request is in progress.
        when STATUS.abort then ""
        else  ""

  showError: (errorMsg, className = "error", header = "") ->
    MehnazApp.Common.FlashNotification.showFlash({"header": header, "content": errorMsg}, className)