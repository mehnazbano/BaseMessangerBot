require 'spec_helper'
require "../../app/models"
describe Feed do
  context 'test to say true' do
    it 'My feed is true' do
      feed = Feed.new()
      expect(feed.say_hello).to be true
    end
  end
end
