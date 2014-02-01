class CallsController < ApplicationController
  def index
    @call = Call.new
  end

  def sms_verify
    puts "Hello, twilio!!"
    render :json => {'code' => 0, 'message' => 'Hello, twilio!!'}
  end

  def create

    @call = Call.new
    @call.message =  params[:call][:message]
    @call.to =  params[:call][:to]
    if @call.save

      @msg = params[:call][:message]
      @sender = params[:call][:to]

      #put your own credentials here
      account_sid = 'ACb024b692d223ccb5a8988cba4073e226'
      auth_token = '84d20c23c8d5496a9066668675362702'

      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new account_sid, auth_token

      @call = @client.account.calls.create(
          :from => '+815031595958',   # From your Twilio number
          :to => '+818013316810',     # To any number
          # Fetch instructions from this URL when the call connects
          :url => "http://twilio-call-client.herokuapp.com/calls/callback"
      )

      render 'show'
    else
      render 'index'
    end
  end

  def callback

    @msg = Call.find(Call.count).message
    @sender = Call.find(Call.count).to

    xml = Builder::XmlMarkup.new(indent: 2)

    render xml: xml.Response {
      xml.Gather(action: 'http://twilio-call-client.herokuapp.com/calls/receive', numDigits: 1, timeout: 5) do
        xml.Say(@msg, voice: 'woman', language: 'ja-JP')
        #xml.Say('番号を入力してください', voice: 'woman', language: 'ja-JP')
      end
      xml.Say(@sender, voice: 'woman', language: 'ja-JP')
    }
  end

  def receive
    xml = Builder::XmlMarkup.new(indent: 2)

    render xml: xml.Response {
      xml.Say("あなたが押したのは #{params[:Digits]} です", voice: 'woman', language: 'ja-JP')
    }
  end

end
