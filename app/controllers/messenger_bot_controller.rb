class MessengerBotController < ActionController::Base
  require 'open-uri'
  require 'nokogiri'
  require 'net/http'
  require 'net/https'
  require 'httparty'

  def message(event, sender)
    if params['entry'][0]['messaging'][0]['message']['attachments'].present?
      ticket = ::Ticket.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id']).sort_by(&:created_at).reverse.first
      feedback = ::Feedback.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id']).sort_by(&:created_at).reverse.first
      if ticket.present? && ( feedback.blank? || (ticket.try(:created_at ) > feedback.try(:created_at)) )
        ticket.data = open(params['entry'][0]['messaging'][0]['message']['attachments'][0]['payload']['url'])
        ticket.save
        sender.reply(message = { text: "Thanks, got the attachment. We'll notifying you offline once it is resolved. Is there anything else I can help you with?", quick_replies: [{ content_type: "text", title: "Continue", payload: "intro"},{ content_type: "text", title: "May be later!", payload: "exit"}]})
      elsif feedback.present?
        feedback.data = open(params['entry'][0]['messaging'][0]['message']['attachments'][0]['payload']['url'])
        feedback.save
        sender.reply(message = { text: "Thanks, got the attachment. We are continously trying to improve our services. Is there anything else I can help you with?", quick_replies: [{ content_type: "text", title: "Continue", payload: "intro"},{ content_type: "text", title: "May be later!", payload: "exit"}]})
      end
    else
      @query_string = event['message']['text']
      query_string = @query_string.gsub(' ', '%20')
      session_id = event['sender']['id']
      version = DateTime.now().strftime('%Y%m%d')
      message = map_entity_to_value(params)
      sender.reply(message)
    end
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when 'select_category'
      message = select_ticket_category
    when 'select_severity'
      case params['entry'][0]['messaging'][0]['message']['text']
      when 'Access is denied'
        ticket_cat = 'Access Denied'
      when 'Forgot password'
        ticket_cat = 'Forgot password'
      when 'Content creation'
        ticket_cat = 'Content creation'
      end
      if defined?(ticket_cat) && ticket_cat.present?
        data_analy = {
          event: 'CUSTOM_APP_EVENTS',
          custom_events: [{
            _eventName: ticket_cat,
            _valueToSum: 1,
          }],
          advertiser_tracking_enabled: 0,
          application_tracking_enabled: 0,
          extinfo: ['mb1'],
          page_id: 119934735348876,
          page_scoped_user_id: params['entry'][0]['messaging'][0]['sender']['id'].to_i
        }
        HTTParty.post('https://graph.facebook.com/687315501471774/activities', body: data_analy.to_json,  headers: { "Content-Type" => "application/json"})
      end
      ticket = ::Ticket.create(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], category: params['entry'][0]['messaging'][0]['message']['text'], status: 1)
      message = select_ticket_severity
    when 'Welcome to Mehnaz Biot'
      message = bot_intro
    when 'feedback'
      message = select_feedback_options
    when 'reason_input'
      feedback = ::Feedback.create(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], option: params['entry'][0]['messaging'][0]['postback']['title'])
      message = { text: 'Thank you 👍. Please help us by providing reason for your feedback.'}
    when 'yes_attachment'
      message = { text: "Please upload by clicking attachment link below."}
    when 'no_attachment'
      message = { text: "Thanks, we'll notifying you offline once it is resolved. Is there anything else I can help you with?", quick_replies: [{ content_type: "text", title: "I would like to continue", payload: "intro"}, { content_type: "text", title: "May be later!", payload: "exit"}]}
    when 'yes_feedback_attachment'
      message = { text: "Please upload by clicking attachment link below."}
    when 'no_feedback_attachment'
      message = { text: "Thanks. Is there anything else I can help you with?", quick_replies: [{ content_type: "text", title: "I would like to continue", payload: "intro"}, { content_type: "text", title: "May be later!", payload: "exit"}]}
    when 'intro'
      message = bot_intro
    when 'raise_ticket'
      case params['entry'][0]['messaging'][0]['message']['text']
      when 'Severity 1 🔴', 'Severity 1', 'sev 1', 'sev1'
        ticket_sev = 'Severity 1'
      when 'Severity 2 🔵', 'Severity 2', 'sev 2', 'sev2'
        ticket_sev = 'Severity 2'
      when 'Severity 3 ⚫', 'Severity 3', 'sev 3', 'sev3'
        ticket_sev = 'Severity 3'
      when 'Severity 4 ⚪', 'Severity 4', 'sev 4', 'sev4'
        ticket_sev = 'Severity 4'
      end
      message = { text: 'Please provide detailed ticket description'}
      data_analy = {
        event: 'CUSTOM_APP_EVENTS',
        custom_events: [{
          _eventName: ticket_sev,
          _valueToSum: 1,
        }],
        advertiser_tracking_enabled: 0,
        application_tracking_enabled: 0,
        extinfo: ['mb1'],
        page_id: 119934735348876,
        page_scoped_user_id: params['entry'][0]['messaging'][0]['sender']['id'].to_i
      }
      HTTParty.post('https://graph.facebook.com/687315501471774/activities', body: data_analy.to_json,  headers: { "Content-Type" => "application/json"})
      ticket = ::Ticket.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], description: nil).sort_by(&:created_at).reverse.first
      if ticket.present?
        ticket.severity = ticket_sev
        ticket.save
      end
    when 'exit'
      message = { text: "Would you like to rate this conversation(> 8 for Highly Safisfied, > 6 for Safisfied, > 4 for Average, < 4 for below average?", quick_replies: [{ content_type: "text", title: "Greater than 8", payload: "highly_satisfied"}, { content_type: "text", title: "Greater than 6", payload: "highly_satisfied"}, { content_type: "text", title: "Greater than 4", payload: "satisfied"}, { content_type: "text", title: "Less than 4", payload: "not_satisfied"}, { content_type: "text", title: "May be later!", payload: "quit"}]}
    when 'highly_satisfied', 'satisfied', 'not_satisfied'
      message = { text: 'Thank you for your valuable feedback. It was nice talking to you. Bye 😊.'}
      rating = nil
      case params['entry'][0]['messaging'][0]['message']['text'].downcase
      when "greater than 8"
        rating = params['entry'][0]['messaging'][0]['message']['text']
      when "greater than 6"
        rating = params['entry'][0]['messaging'][0]['message']['text']
      when "greater than 4"
        rating = params['entry'][0]['messaging'][0]['message']['text']
      when "less than 4"
        rating = params['entry'][0]['messaging'][0]['message']['text']
      end
      if rating.present?
        data_analy = {
          event: 'CUSTOM_APP_EVENTS',
          custom_events: [{
            _eventName: rating,
            _valueToSum: 1,
          }],
          advertiser_tracking_enabled: 0,
          application_tracking_enabled: 0,
          extinfo: ['mb1'],
          page_id: 119934735348876,
          page_scoped_user_id: params['entry'][0]['messaging'][0]['sender']['id'].to_i
        }
        HTTParty.post('https://graph.facebook.com/687315501471774/activities', body: data_analy.to_json,  headers: { "Content-Type" => "application/json"})
      end
    when 'quit'
      message = { text: 'Bye 😊. It was nice talking to you.'}
    when 'play'
      message = { text: 'Guess movie name - 🕷️🚶'}
    else
      message = { text:  'I am still under construction 🏗️'}
    end
    sender.reply(message)
    File.open('junk.txt', 'a') do |f2|
      f2.puts ','
      f2.puts params['entry'][0]['messaging'][0]['postback']['title']
    end
  end

  private

  def map_entity_to_value(params=nil)
    message =
      case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].keys.first
      when 'contact'
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
        when 'hi', 'hey', 'hello'
          response = bot_intro
        when 'bye'
          'Bye 😊. It was nice talking to you.'
        else
          'I didnt get you 🏗️'
        end
      when 'wit_course'
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
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
          'I didnt get you 🏗️'
        end
      when 'wit_ticket'
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
        when 'ticket'
          response = select_ticket_category
        when  'my tickets'
          ticket_stats(params['entry'][0]['messaging'][0]['sender']['id'])
        when 'open tickets'
          ticket_stats(params['entry'][0]['messaging'][0]['sender']['id'], 1)
        when 'closed tickets'
          ticket_stats(params['entry'][0]['messaging'][0]['sender']['id'], 2)
        else
          ticket = ::Ticket.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], description: nil).sort_by(&:created_at).reverse.first
          if ticket.present?
            ticket.description = params['entry'][0]['messaging'][0]['message']['text']
            ticket.save
            response = request_for_attachment(ticket)
          else
            'I didnt get you 🏗️'
          end
        end
      when 'wit_severity'
        ticket = ::Ticket.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], description: nil).sort_by(&:created_at).reverse.first
        if ticket.present?
          ticket.severity = params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
          ticket.save
        end
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
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
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
        when 'content creation', 'forgot password', 'access denied', 'access is denied'
          response = select_ticket_severity
          ticket = ::Ticket.create(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], category: params['entry'][0]['messaging'][0]['message']['text'], status: 1)
          #HTTParty.post('https://graph.facebook.com/687315501471774/activities', body: data_analy.to_json,  headers: { "Content-Type" => "application/json"})
        else
          'Please specify appropriate category.'
        end
      when 'wit_feedback'
        case params['entry'][0]['messaging'][0]['message']['nlp']['entities'].values.flatten.first['value'].downcase
        when 'feedback'
          response = select_feedback_options
        when 'Excellent', 'Okay', 'Not Okay', 'Good'
          feedback = ::Feedback.create(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], option: params['entry'][0]['messaging'][0]['message']['text'])
          'Thank you 👍. Please help us by providing reason for your feedback.'
        else
          # "We'll keep trying to improve our services. 😃️"
          feedback = ::Feedback.where(fb_app_user_id: params['entry'][0]['messaging'][0]['sender']['id'], description: nil).sort_by(&:created_at).reverse.first
          if feedback.present?
            feedback.description = params['entry'][0]['messaging'][0]['message']['text']
            feedback.save
          end
          response = feedback_attachment
        end
      else
        'I didnt get you 🏗️'
      end
    File.open('junk.txt', 'a') do |f2|
      f2.puts ','
      f2.puts params['entry'][0]['messaging'][0]['message']['text']
    end
    if defined?(response) && response.present?
      JSON.parse(response.to_json)
    else
      { text: message }
    end
  end

  def ticket_stats(sender_id, status=nil)
    if status == 1
      tickets = ::Ticket.where(fb_app_user_id: sender_id, status: 1, :description.not_eq => nil)
    elsif status == 2
      tickets = ::Ticket.where(fb_app_user_id: sender_id, status: 2, :description.not_eq => nil)
    else
      tickets = ::Ticket.where(fb_app_user_id: sender_id, :description.not_eq => nil )
    end
    if tickets.present?
      tickets.map{|tic| tic.description.present? ? "FBTICK#{tic.id} - #{tic.description}" : nil }.compact.flatten.to_sentence.truncate(639)
    else
      "No tickets found"
    end
  end

  def bot_intro
    {
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [{
            title: "Hi, I am GTIO BOT 🤖. How can I help you?",
            subtitle: "Tap a button to specify your concern.",
            image_url: 'https://facbot.herokuapp.com/profile.png',
            default_action: {
              type: 'web_url',
              url: 'https://facbot.herokuapp.com/profile.png',
              messenger_extensions: true,
              webview_height_ratio: 'tall',
              fallback_url: 'https://facbot.herokuapp.com/profile.png'
            },
            buttons: [
              {
                type: "postback",
                title: "Raise a Ticket 🎟️",
                payload: "select_category",
              },
              {
                type: "postback",
                title: "Give Feedback ✍️",
                payload: "feedback",
              },
              {
                type: "postback",
                title: "Talk Later 😊",
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
          title: "Access is denied",
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
        }
        # {
        #   content_type: "text",
        #   title: "Talk later 😊",
        #   payload: "exit"
        # }
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
        }
        # {
        #   content_type: "text",
        #   title: "Talk later 😊",
        #   payload: "exit"
        # }
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

  def request_for_attachment(ticket)
    {
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [{
            title: "Okay, got it. We have registered your ticket( id - FBTICKET#{ticket.id} ).",
            subtitle: "Would you like to attach some image/ PDF/ DOC to this Ticket?",
            buttons: [
              {
                type: "postback",
                title: "Yes",
                payload: "yes_attachment",
              },
              {
                type: "postback",
                title: "Not required",
                payload: "no_attachment",
              }
            ],
          }]
        }
      }
    }
  end

  def feedback_attachment
    {
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [{
            title: "Okay, got it.",
            subtitle: "Would you like to attach some image/ PDF/ DOC to this Ticket?",
            buttons: [
              {
                type: "postback",
                title: "Yes",
                payload: "yes_feedback_attachment",
              },
              {
                type: "postback",
                title: "Not required",
                payload: "no_feedback_attachment",
              }
            ],
          }]
        }
      }
    }
  end
end
