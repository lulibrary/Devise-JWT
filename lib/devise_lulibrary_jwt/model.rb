require 'devise_lulibrary_jwt/strategy'

module Devise
  module Models
    module JwtAuthenticatable
      extend ActiveSupport::Concern

      module ClassMethods

        def find_or_create_from_jwt_hash jwt

          auth_params = {}

          jwt_keymap.each_pair { |k,v| auth_params[v] = jwt[k] }

          where(username: auth_params["username"]).first_or_create auth_params

        end

      end

    end
  end
end
