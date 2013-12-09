class CallsController < ApplicationController
  def index
    ## put your own credentials here
    #account_sid = 'ACb024b692d223ccb5a8988cba4073e226'
    #auth_token = '84d20c23c8d5496a9066668675362702'
    #
    ## set up a client to talk to the Twilio REST API
    #@client = Twilio::REST::Client.new account_sid, auth_token
    #
    #@call = @client.account.calls.create(
    #    :from => '+815031595958',   # From your Twilio number
    #    :to => '+8108013316810',     # To any number
    #    # Fetch instructions from this URL when the call connects
    #    :url => 'http://your URL/call.xml'
    #)

  end
end
