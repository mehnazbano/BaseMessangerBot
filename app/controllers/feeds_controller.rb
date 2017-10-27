class FeedsController < ApplicationController
  def index
  end

  def show
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id
  	if @feed.save
      @success = true
  	end
    respond_to do |format|
      if @success
        format.js
      else
        format.js { render :partial => 'error' }
      end
    end
  end

  def edit
  end

  def update
  end

  private

  def feed_params
    params.require(:feed).permit(:description, :data)
  end
end
