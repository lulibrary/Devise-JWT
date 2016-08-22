require 'devise'

require "devise_lulibrary_jwt/version"
require 'devise_lulibrary_jwt/strategy'
require 'devise_lulibrary_jwt/model'

module Devise

  mattr_accessor :jwt_secret
  @@jwt_secret = nil

  mattr_accessor :jwt_issuer
  @@jwt_issuer = nil

  mattr_accessor :jwt_audience
  @@jwt_audience = nil

  mattr_accessor :verify_aud
  @@verify_aud = true

  mattr_accessor :verify_iss
  @@verify_iss = true

  mattr_accessor :verify_iat
  @@verify_iat = true

  mattr_accessor :jwt_create_user
  @@find_or_create_on_auth = true

end

Devise.add_module(:jwt_authenticatable, strategy: true, model: 'devise_lulibrary_jwt/model')
