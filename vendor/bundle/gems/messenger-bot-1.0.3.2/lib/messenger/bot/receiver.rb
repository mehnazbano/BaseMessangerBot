module Messenger
  module Bot
    class Receiver
      def self.share(data)
        messaging_events = data["entry"].first["messaging"]
        messaging_events.each_with_index do |event, key|
          if event["message"] && !defined?(message).nil?
            p 'share11111'
            self.class.send(:message, event)
          elsif event["postback"] && !defined?(postback).nil?
            p 'share222222'
            self.class.send(:postback, event)
          elsif event["delivery"] && !defined?(delivery).nil?
            p p 'share333333333'
            self.class.send(:delivery, event)
          end 
        end 
      end

      def self.define_event(event, &block)
        self.class.instance_eval do
          define_method(event.to_sym) do |event|
            yield(event, Messenger::Bot::Transmitter.new(event["sender"]["id"]))
          end
        end
      end
    end
  end
end
