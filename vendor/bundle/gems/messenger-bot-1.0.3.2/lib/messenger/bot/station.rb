module Messenger
  module Bot
    class Space::StationController < ::MessengerBotController

      skip_before_filter :authenticate_user!
      # before_action :authenticate, only: [:receive]
      # protect_from_forgery with: :null_session

      def validation
        p 'params["hub.verify_token"]'
        p params
        if params["hub.verify_token"] === Messenger::Bot::Config.validation_token
          return render json: params["hub.challenge"]
        end
        render body: "Error, wrong validation token"
      end

      def receive
        Rails.logger.error('Mehnaz appp receive start')
        p 'initial paramsss-----'
        Messenger::Bot::Receiver.share(params)
        p 'patrasmsmsm iwiiidiid'
        p params
        p params["entry"]
        p params["entry"].count
        params["entry"].each do |entry|
          messaging_events = entry["messaging"]
          p 'messaging_events'
          p messaging_events
          p messaging_events.count
          messaging_events.each_with_index do |event, key|
            sender = Messenger::Bot::Transmitter.new(event["sender"]["id"])
            if event["message"] && !defined?(message).nil? && event["message"]["quick_reply"].nil?
              Rails.logger.error("11111")
              send(:message, event, sender)
            elsif (event["postback"] && !defined?(postback).nil?) || (event["message"] && event["message"]["quick_reply"].present?)
              if event["message"].present?
                Rails.logger.error("22222")
                event["postback"] = event["message"]["quick_reply"]
                send(:postback, event, sender)
              else
                Rails.logger.error("333333")
                send(:postback, event, sender)
              end
            elsif event["delivery"] && !defined?(delivery).nil?
              Rails.logger.error("444444")
              send(:delivery, event, sender)
            elsif event["optin"]
              Rails.logger.error("555555")
              send(:optin, event, sender)
            end
          end
        end
        Rails.logger.error('Mehnaz appp receive end')
        render body: "ok"
      end

      def authenticate
        return true if Messenger::Bot::Config.secret_token.nil?
        signature = "sha1=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Messenger::Bot::Config.secret_token, request.body.read)
        return render(body: "Error, Signatures didn't match", status: 500) unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      end
    end
  end
end
