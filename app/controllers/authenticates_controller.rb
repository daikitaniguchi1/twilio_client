class AuthenticatesController < ApplicationController

  def verify
    render :json => {
        token: params[:auth_token],
        mobile_numner: params[:mobile_number]
    }
  end

end
