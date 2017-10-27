module Messenger
  module Bot
    class Space::StationController < ::MessengerBotController
      skip_before_filter :verify_authenticity_token
      skip_before_filter :authenticate_user!
      # before_action :authenticate, only: [:receive]

      def validation
        p 'params["hub.verify_token"]'
        p params
        if params["hub.verify_token"] === Messenger::Bot::Config.validation_token
          return render json: params["hub.challenge"]
        end
        render body: "Error, wrong validation token"
      end

      def receive
        Messenger::Bot::Receiver.share(params)
        params["entry"].each do |entry|
          messaging_events = entry["messaging"]
          messaging_events.each_with_index do |event, key|
            sender = Messenger::Bot::Transmitter.new(event["sender"]["id"])
            if event["message"] && !defined?(message).nil? && event["message"]["quick_reply"].nil?
              p "11111"
              send(:message, event, sender)
            elsif (event["postback"] && !defined?(postback).nil?) || (event["message"] && event["message"]["quick_reply"].present?)
              if event["message"].present?
                p '22222'
                event["postback"] = event["message"]["quick_reply"]
                send(:postback, event, sender)
              else
                p '33333'
                send(:postback, event, sender)
              end
            elsif event["delivery"] && !defined?(delivery).nil?
              p '44444'
              send(:delivery, event, sender)
            elsif event["optin"]
              p '555555'
              send(:optin, event, sender)
            end
          end
        end
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
