MehnazApp.Form = {} unless MehnazApp.Form?


MehnazApp.Form.EditBlogpost = do ->


	_callEditForm= ->
	  alert("i am ready")

	init : ->
		$('#editBlogpost').click(_callEditForm)