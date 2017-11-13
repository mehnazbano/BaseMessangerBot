class MessengerBotController < ActionController::Base
  require 'open-uri'
  require 'nokogiri'
  require 'net/http'
  require 'net/https'
  require 'httparty'

  def message(event, sender)
    @query_string = event['message']['text']
    query_string = @query_string.gsub(' ', '%20')
    session_id = event['sender']['id']
    version = DateTime.now().strftime('%Y%m%d')
    api_response = HTTParty.post("https://api.wit.ai/message?v=#{version}&q=#{query_string}", headers: { 'Authorization' => 'Bearer R3PQSNRVIY3S57HLAZGPWR7A52XNFUH3',"Content-Type" => "application/json","Accept" => "application/json"}).parsed_response
    message = map_entity_to_value(api_response)
    sender.reply(message)
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when 'select_category'
      message = select_ticket_category
    when 'select_severity'
      message = select_ticket_severity
    when 'Welcome to Mehnaz Biot'
      message = bot_intro
    when 'feedback'
      message = select_feedback_options
    when 'reason_input'
      message = { text: 'Thank you 👍. Please help us by providing reason for your feedback.'}
    when 'raise_ticket'
      message = { text: 'Please provide detailed ticket description'}
    when 'exit'
      message = { text: 'Bye 😊. It was nice talking to you, hope to see you again.'}
    when 'play'
      message = { text: 'Guess movie name - 🕷️🚶'}
    else
      message = { text:  'I am still under construction 🏗️'}
    end
    sender.reply(message)
  end

  private

  def map_entity_to_value(api_response)
    message =
      case api_response['entities'].keys.first
      when 'contact'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'hi', 'hey', 'hello'
          response = bot_intro
        when 'bye'
          'Bye 😊. It was nice talking to you, hope to see you again.'
        else
          'Under mainteinace - 1 🏗️'
        end
      when 'wit_course'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'aws', 'amazon web services', 'amazon web service'
          'Ahh! thats a nice topic. Amazon Web Services (AWS), a subsidiary of Amazon.com, offers a suite of cloud-computing services that make up an on-demand computing platform.'
        when 'dess', 'di'
          'A digital enterprise/ interactive is an organization that uses technology as a competitive advantage in its internal and external operations.'
        when 'video'
          response = {
            attachment: {
              type: "template",
              payload: {
                template_type: "generic",
                elements: [{
                  title: "Is this the right picture?",
                  subtitle: "Tap a button to answer.",
                  image_url: 'http://www.w3schools.com/css/trolltunga.jpg',
                  buttons: [
                    {
                      type: "postback",
                      title: "Yes!",
                      payload: "yes",
                    },
                    {
                      type: "postback",
                      title: "No!",
                      payload: "no",
                    }
                  ],
                }]
              }
            }
          }
        else
          'Under mainteinace - 2 🏗️'
        end
      when 'wit_ticket'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'ticket'
          response = select_ticket_category
        else
          "😃️ Got it. We'll keep trying to improve our services. 👷‍♀️ Thank you."
        end
      when 'wit_severity'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'severity 1', 'sev 1', 'sev1'
          'Considering your ticket highly critical, please provide detailed ticket description.'
        when 'severity 2', 'sev 2', 'sev2'
          'Considering your ticket critical, please provide detailed ticket description.'
        when 'severity 3', 'sev 3', 'sev3'
          'Considering your ticket less critical, please provide detailed ticket description.'
        when 'severity 4', 'sev 4', 'sev4'
          'Considering your ticket is not critical, please provide detailed ticket description.'
        end
      when 'wit_tic_category'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'content creation', 'forgot password', 'access denied'
          response = select_ticket_severity
        else
          'Please specify appropriate category.'
        end
      when 'wit_feedback'
        case api_response['entities'].values.flatten.first['value'].downcase
        when 'feedback'
          response = select_feedback_options
        when 'Excellent', 'Okay', 'Not Okay', 'Good'
          'Thank you 👍. Please help us by providing reason for your feedback.'
        else
          "😃️ We'll keep trying to improve our services. 👷‍♀️"
        end
      else
        'Under mainteinace - 3 🏗️'
      end
    p 'message=------'
    if defined?(response) && response.present?
      JSON.parse(response.to_json)
    else
      { text: message }
    end
  end

  def bot_intro
    {
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [{
            title: "Hi, I am Tick BOT 🤖. How can I help you?",
            subtitle: "Tap a button to specify your concern.",
            image_url: 'https://pbs.twimg.com/profile_images/899382591236829184/Dk48Lg7S.jpg',
            default_action: {
              type: 'web_url',
              url: 'https://pbs.twimg.com/profile_images/899382591236829184/Dk48Lg7S.jpg',
              messenger_extensions: true,
              webview_height_ratio: 'tall',
              fallback_url: 'https://pbs.twimg.com/profile_images/899382591236829184/Dk48Lg7S.jpg'
            },
            buttons: [
              {
                type: "postback",
                title: "Raise Ticket 🎟️",
                payload: "select_category",
              },
              {
                type: "postback",
                title: "Feedback ✍️",
                payload: "feedback",
              },
              {
                type: "postback",
                title: "No, thanks 😊",
                payload: "exit",
              }
            ],
          }]
        }
      }
    }
  end

  def select_ticket_category
    {
      text: 'Please select a ticket category',
      quick_replies: [
        {
          content_type: "text",
          title: "Access denied",
          payload: "select_severity"
        },
        {
          content_type: "text",
          title: "Forgot password",
          payload: "select_severity"
        },
        {
          content_type: "text",
          title: "Content creation",
          payload: "select_severity"
        },
        {
          content_type: "text",
          title: "No thanks 😊",
          payload: "exit"
        }
      ]
    }
  end

  def select_ticket_severity
    {
      text: 'Please select a issue severity',
      quick_replies: [
        {
          content_type: "text",
          title: "Severity 1 🔴",
          payload: "raise_ticket"
        },
        {
          content_type: "text",
          title: "Severity 2 🔵",
          payload: "raise_ticket"
        },
        {
          content_type: "text",
          title: "Severity 3 ⚫",
          payload: "raise_ticket"
        },
        {
          content_type: "text",
          title: "Severity 4 ⚪",
          payload: "raise_ticket"
        },
        {
          content_type: "text",
          title: "No thanks 😊",
          payload: "exit"
        }
      ]
    }
  end

  def select_feedback_options
    {
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [{
            title: "Please help us by selecting anyone of below options",
            buttons: [
              {
                type: "postback",
                title: "Excellent 😃️",
                payload: "reason_input",
              },
              {
                type: "postback",
                title: "Good 😊",
                payload: "reason_input",
              },
              {
                type: "postback",
                title: "Okay 🙂",
                payload: "reason_input",
              }
            ],
          }]
        }
      }
    }
  end

  def toi_data_call(location='chennai')
    # news = HTTParty.get('https://newsapi.org/v1/articles?source=the-times-of-india&sortBy=top&apiKey=e862f5c9b8e54f90a7a4c53e16f4a4e3')
    data = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{location}&key=AIzaSyAzCT4LdFbRdL-WdbD7bEu6KE5CVPpx-7M")
  end
end
