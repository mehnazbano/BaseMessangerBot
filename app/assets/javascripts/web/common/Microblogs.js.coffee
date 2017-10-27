MehnazApp.Common = {} unless MehnazApp.Common?


MehnazApp.Common.DropdownSelection = do ->
  _microblog_community = null
  __microblog_stat_community = null

  _updateNewDropdownlist = ->
    if $(this).val().length isnt 0
      $('.microblog_type').show()
    else
      $('.microblog_type').hide()
      $('.microblog_status').hide()

  _updateStatusDropdownlist = ->
    if $(this).val().length isnt 0
      $('.microblog_status').show()
    else
      $('.microblog_status').hide()

  init : ->
    $('.microblog_type').hide()
    $('.microblog_status').hide()
    _microblog_community = $('.microblog_community_id').on('click', _updateNewDropdownlist)
    _microblog_stat_community =  $('.microblog_type .select_dropdown').on('click', _updateStatusDropdownlist)