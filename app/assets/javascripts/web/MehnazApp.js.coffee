window.MehnazApp = do ->
	_config = {}
	# ###MehnazApp.init
	# This function is called after the dom is ready to and **$** is available
	init: ->
		MehnazApp.Form.AutoSuggest.init()
		MehnazApp.Form.EditBlogpost.init()
		MehnazApp.Common.DropdownSelection.init()
		MehnazApp.Form.Common.init()
		MehnazApp.Form.Feed.init()
		MehnazApp.AutoLoading.Containers.init()
		MehnazApp.AutoLoading.LoadMore.init()
		MehnazApp.AutoLoading.AjaxContainer.init()
		MehnazApp.InteractiveContainer.init()
		
		return true
	# ###MehnazApp._config
	#Returns the config hash set in the init function
	#
	# ####Returns
	# **config** : A hash that is an application level config which is set on the server side
	config: ->
		_config
$(MehnazApp.init)
