class UsersController < ApplicationController
  def index
  end

  def show
  end

  def my_timeline
  	@feeds = Feed.all.page(@page).per(2)
  	p @feeds
  end

  # Handles messages events
  def handle_message
    #(sender_psid, received_message)
  end

  # Handles messaging_postbacks events
  def handle_postback
    #(sender_psid, received_postback)
  end

  # Sends response messages via the Send API
  def call_send_api
    #(sender_psid, response)
  end
end
