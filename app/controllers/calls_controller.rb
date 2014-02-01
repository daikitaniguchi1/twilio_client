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
          "api_request_error: media_id #{@media_id} :#{e.message}"
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
    raise StandardError, "Body isn't contain underscore" if !params[:Body].include?("_")
    raise StandardError, 'From is invalid' if params[:From].nil?
  end

  def format_params
    body = params[:Body].split("_")
    @media_id = body[0]
    @url = get_reqest_url(@media_id)
    @token = body[1]
    @mobile_number  = params[:From].sub(/^\+81/, '0')

    raise StandardError, 'url is invalid' if @url.nil?
    raise StandardError, 'token is invalid' if @token.nil?
    raise StandardError, 'mobile_number is invalid' if @mobile_number.nil?
  end

  def request_api
    res = Net::HTTP.post_form(URI.parse(@url),
                        {
                            'auth_token' => @token,
                            'mobile_number' => @mobile_number
                        })
    p res.code
    raise StandardError, 'error.' if res.code != 200
  end


  def get_reqest_url(media_id)
    # return Media.find(media_id).url
    return 'http://pointbook.herokuapp.com/users/verify'
  end

end
