module BlogpostsHelper

  def location_hash_for_autosuggest(location)
 	  {
 	  id: location.id,
 	  name: location.name.html_safe
 	  }
 	end

end
