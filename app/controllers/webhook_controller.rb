# class WebhookController < ApplicationController
#   def index
#     p 'webhookk---'
#     p params
#     challenge = params['hub.challenge']
#     verify_token = params['hub.verify_token']
#     p params['hub.verify_token']
#     if (verify_token === '123456789')
#       respond_to do |format|
#         format.html { render :text => challenge }
#       end
#     else
#       respond_to do |format|
#         format.html { render :text => 'Verification failed' }
#       end
#     end
#   end
# end
