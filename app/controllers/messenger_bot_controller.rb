class MessengerBotController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  require 'net/http'
  require 'net/https'

  def message(event, sender)
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    # "Reply: #{event['message']['text']}"
    p 'sender'
    p sender
    sender.reply({ text: "Reply: we are good" })
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
    end
  end
end
