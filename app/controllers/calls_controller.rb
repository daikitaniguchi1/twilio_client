class CallsController < ApplicationController
  require 'net/http'
  require 'uri'

  def sms_verify
    begin
      params_check
      format_params
      request_api
    rescue => e
      render :json => {
          code: 400,
          message: e.message
      }
      logger.error(
          "api_request_error: media_id #{media_id} :#{e.message}"
      )
      return
    ensure
      puts "Hello, twilio!!"
    end
    render :json => {code: 0}
  end

  private

  def params_check
    raise StandardError, 'Body is invalid' if params[:Body].nil?
    raise StandardError, "Body isn't contain underscore" if params[:Body].include?("_")
    raise StandardError, 'From is invalid' if params[:From].nil?
  end

  def format_params
    body = params[:Body].split("_")
    media_id = body[0]
    @url = get_reqest_url(media_id)
    @token = body[1]
    @mobile_number  = params[:From].sub(/^\+81/, '0')

    raise StandardError, 'url is invalid' if url.nil?
    raise StandardError, 'token is invalid' if token.nil?
    raise StandardError, 'mobile_number is invalid' if mobile_number.nil?
  end

  def request_api
    res = Net::HTTP.post_form(URI.parse(@url),
                        {
                            'auth_token' => @token,
                            'mobile_number' => @mobile_number
                        })
    raise StandardError, 'error.' if res.code != 200
  end


  def get_reqest_url(media_id)
    # return Media.find(media_id).url
    return 'http://twilio-call-client.herokuapp.com/authenticates/verify'
  end



  def index
    @call = Call.new
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
