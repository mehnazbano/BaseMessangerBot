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

  draw = (data) ->
    color = d3.scaleOrdinal(d3.schemeCategory10)
    width = 420
    barHeight = 20
    x = d3.scaleLinear().range([
      0
      width
    ]).domain([
      0
      d3.max(data)
    ])
    chart = d3.select('#graph').attr('width', width).attr('height', barHeight * data.length).style("background-color", "yellow");
    bar = chart.selectAll('g').data(data).enter().append('g').attr('transform', (d, i) ->
      'translate(0,' + i * barHeight + ')'
    )
    bar.append('rect').attr('width', x).attr('height', barHeight - 1).style 'fill', (d) ->
      color d
    bar.append('text').attr('x', (d) ->
      x(d) - 10
    ).attr('y', barHeight / 2).attr('dy', '.35em').style('color', 'red').text (d) ->
      d
    return

  error = ->
    console.log 'error'
    return


  init : ->
    $('.microblog_type').hide()
    $('.microblog_status').hide()
    _microblog_community = $('.microblog_community_id').on('click', _updateNewDropdownlist)
    _microblog_stat_community =  $('.microblog_type .select_dropdown').on('click', _updateStatusDropdownlist)
    $(document).on 'ready page:load', ->
      if $('#visualization').length > 0
        category_foam = []
        $.ajax
          url: MehnazApp.Common.Util.computePath '/home/foam_tree'
          dataType: 'json'
          jsonpCallback: 'callback'
          success: (data) ->
            console.log(data)
            for k,v of data
              foam_hash = {}
              foam_hash['label'] = k
              foam_hash['weight'] = v
              category_foam.push foam_hash
            console.log('category_foam')
            console.log(category_foam)
            foamtree = new CarrotSearchFoamTree(
              id: 'visualization'
            )
            foamtree.set({
              dataObject: groups: category_foam
            });
      if $('#graph').length > 0
        $.ajax
          url: MehnazApp.Common.Util.computePath '/home/d3_analy'
          dataType: 'json'
          jsonpCallback: 'callback'
          success: (data) ->
            draw(data)
