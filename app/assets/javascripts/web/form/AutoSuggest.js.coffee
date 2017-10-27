MehnazApp.Form = {} unless MehnazApp.Form?


MehnazApp.Form.AutoSuggest = do ->
	_locationSearchUrl = null
	_locationSearch = null


	_convertToAutosuggest = ->
		if _locationSearch.length isnt 0
			_locationSearch.tokenInput(_locationSearchUrl, {
				theme: "knome",
				hintText: "Type in a search term",
				tokenDelimiter: ","
				minChars: 0,
				searchDelay: 600,
				tokenLimit: 1,
				preventDuplicates: true,
				queryParam: "search",
				newTokenText: "new",
				noResultsText: "No results",
				searchingText: "Searching..",
				onAdd: (item) =>
					location_id = $('#locationTokenInput').val()
					url = MehnazApp.Common.Util.computePath("/blogposts/get_location_code")
					data =
						"location": location_id
			})

	init : ->
		_locationSearchUrl = MehnazApp.Common.Util.computePath("/blogposts/get_locations")
		_locationSearch = $(".js_location_tokeninput")
		_convertToAutosuggest()