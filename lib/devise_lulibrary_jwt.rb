require 'devise'

require "devise_lulibrary_jwt/version"
require 'devise_lulibrary_jwt/strategy'
require 'devise_lulibrary_jwt/model'

module Devise



end

Devise.add_module(:jwt_authenticatable, strategy: true, model: 'devise_lulibrary_jwt/model')
