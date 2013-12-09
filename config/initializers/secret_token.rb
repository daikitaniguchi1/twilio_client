# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
TwilioClient::Application.config.secret_key_base = '16bf89c49dc9f5e47f59b9a32f8173ce7cc3666e75a15fe4ad2bf81c1c4869795f1baf50b8621792ce18bb20003889b2db8268355909e02d383e699a040af1a7'
