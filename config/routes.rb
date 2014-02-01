TwilioClient::Application.routes.draw do
  post "/twilio" => "calls#sms_verify"
  resources :authenticates do
    collection do
      post 'verify'
    end
  end
end
