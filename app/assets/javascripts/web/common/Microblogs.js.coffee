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

  draw = (dataset) ->
    diameter = 900
    color = d3.scaleOrdinal(d3.schemeCategory20)
    bubble = d3.pack(dataset).size([
      diameter
      diameter
    ]).padding(30)
    svg = d3.select('#chart').append('svg').attr('width', diameter).attr('height', diameter).attr('class', 'bubble')
    nodes = d3.hierarchy(dataset).sum((d) ->
      d.responseCount
    )
    node = svg.selectAll('.node').data(bubble(nodes).descendants()).enter().filter((d) ->
      !d.children
    ).append('g').attr('class', 'node').attr('transform', (d) ->
      'translate(' + d.x + ',' + d.y + ')'
    )
    node.append('title').text (d) ->
      d.data.facilityId + ' (' + d.data.responseCount + ')'
    node.append('circle').attr('r', (d) ->
      d.r
    ).style 'fill', (d) ->
      color Math.floor(Math.random() * 10)
    node.append('text').attr('dy', '.3em').style('text-anchor', 'middle').style('font-size', (d) ->
      radius = parseInt(d.r)
      if radius> 0 && radius <= 15
        '5px'
      else if radius > 15 && radius <= 25
        '7px'
      else if radius > 25 && radius <= 30
        '9px'
      else if radius > 30 && radius <= 70
        '10px'
      else if radius > 70
        '20px'
    ).text (d) ->
      d.data.facilityId.substring(0, d.r / 3) + '(' + d.data.responseCount + ')'
    d3.select(self.frameElement).style 'height', diameter + 'px'

  init : ->
    $('.microblog_type').hide()
    $('.microblog_status').hide()
    initvar = document.getElementById('data_details')
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
              foam_hash['label'] = "#{k} (#{v})"
              foam_hash['weight'] = v
              foam_hash['keyword'] = k
              category_foam.push foam_hash
            foamtree = new CarrotSearchFoamTree(
              id: 'visualization'
            )
            foamtree.set({
              dataObject: groups: category_foam
            });
            foamtree.set onGroupSelectionChanged: (info) ->
              jQuery('#data_details').html('')
              initvar.innerHTML = "Conversation details for "+ info.groups[0].label+""
              keyword = info.groups[0].keyword
              $.ajax
                url: MehnazApp.Common.Util.computePath '/home/keyword_search'
                data: {
                "keyword": keyword
                }
                type: 'get'
                dataType: 'json'
                success: (data) ->
                  $('#data_details').html(data.content)

      if $('#chart').length > 0
        $.ajax
          url: MehnazApp.Common.Util.computePath '/home/d3_analy'
          dataType: 'json'
          jsonpCallback: 'callback'
          success: (data) ->
            draw(data)
