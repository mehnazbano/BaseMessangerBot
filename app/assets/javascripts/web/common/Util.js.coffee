MehnazApp.Common = {} unless MehnazApp.Common?

###
=MehnazApp.Common.Util=

This module is a Utility module which comprises of common functions that could be used across various modules.
###
MehnazApp.Common.Util = do ->

	# Key codes added from http://www.webonweboff.com/tips/js/event_key_codes.aspx

	computePath: (uri, includeLocale) ->
		if includeLocale is undefined
		  includeLocale = true
		else if includeLocale isnt false
		  includeLocale = true

		if uri[0] isnt "/"
		  uri = "/" + uri

		rel_path = "/" + uri
		rel_path = rel_path.replace("\/\/", "\/")

		# return
		rel_path

	init: ->