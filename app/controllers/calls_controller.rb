class CallsController < ApplicationController
  require 'net/http'
  require 'uri'

  def sms_verify
    begin
      params_check
      format_params
      request_api
      logger.error("success!")
      render :json => { code: 0 }
    rescue => e
      logger.error(
          "api_request_error: media_id #{@media_id} :#{e.message}"
      )
      render :json => {
          code: 400,
          message: e.message
      }
      return
    ensure
      puts "fin."
    end
  end

  private

  def params_check
    msg = 'Body is invalid' if params[:Body].nil?
    msg = "Body isn't contain underscore" if !params[:Body].include?("_")
    msg = 'From is invalid' if params[:From].nil?
    raise StandardError, msg if !msg.nil?
  end

  def format_params
    body = params[:Body].split("_")
    @media_id = body[0]
    @url = get_reqest_url(@media_id)
    @token = body[1]
    @mobile_number  = params[:From].sub(/^\+81/, '0')

    msg = 'url is invalid' if @url.nil?
    msg = 'token is invalid' if @token.nil?
    msg = 'mobile_number is invalid' if @mobile_number.nil?
    raise StandardError, msg if !msg.nil?
  end

  def request_api
    res = Net::HTTP.post_form(URI.parse(@url),
                        {
                            'auth_token' => @token,
                            'mobile_number' => @mobile_number
                        })
    raise StandardError, 'error.' if res.code != "200"
  end


  def get_reqest_url(media_id)
    # return Media.find(media_id).url
    return 'http://pointbook.herokuapp.com/users/verify'
  end

end
