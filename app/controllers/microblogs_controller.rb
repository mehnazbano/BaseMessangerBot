class MicroblogsController < ApplicationController
	def index
	  @microblogs = Microblog.all
	end
	def new
	  @microblog = Microblog.new
    end
    def edit
    end
end
