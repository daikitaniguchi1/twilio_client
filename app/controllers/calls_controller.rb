class CallsController < ApplicationController
  def index
    @call = Call.new
  end

  def create

    @msg =  params[:call][:message]

    #put your own credentials here
    account_sid = 'ACb024b692d223ccb5a8988cba4073e226'
    auth_token = '84d20c23c8d5496a9066668675362702'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    @call = @client.account.calls.create(
        :from => '+815031595958',   # From your Twilio number
        :to => '+818013316810',     # To any number
        # Fetch instructions from this URL when the call connects
        :url => 'http://localhost:3000/calls/callback'
    )

    render 'show'
  end

  def callback
    xml = Builder::XmlMarkup.new(indent: 2)

    render xml: xml.Response {
      xml.Gather(action: 'http://xxx.heroku.com/receive', numDigits: 1, timeout: 10) do
        xml.Say('番号を入力してください', voice: 'woman', language: 'ja-JP')
      end
      xml.Say(@msg, voice: 'woman', language: 'ja-JP')
    }
    #respond_to do |format|
    #  format.xml  {render :xml => ''}
    #end
  end

  def receive
    xml = Builder::XmlMarkup.new(indent: 2)

    render xml: xml.Response {
      xml.Say("あなたが押したのは #{params[:Digits]} です", voice: 'woman', language: 'ja-JP')
    }
  end

end
