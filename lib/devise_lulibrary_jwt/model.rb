require 'devise_lulibrary_jwt/strategy'

module Devise
  module Models
    module JwtAuthenticatable
      extend ActiveSupport::Concern

      module ClassMethods

        Devise::Models.config(self, :jwt_create_user, :jwt_secret, :jwt_issuer, :jwt_audience, :verify_aud, :verify_iss, :verify_iat)

        def find_for_jwt_authentication jwt_claims

          auth_params = {}

          jwt_keymap.each_pair { |k,v| auth_params[v] = jwt_claims[k] }

          auth_key = self.authentication_keys.first.to_s
          auth_key_value = auth_params[auth_key]

          return nil unless auth_key_value.present?

          resource = where(auth_key => auth_key_value).first

          if resource.blank?
            resource = new(auth_params)
          end

          if self.jwt_create_user && resource.new_record?
            resource.save!
          end

          resource

        end

      end

    end
  end
end
