require 'devise/strategies/authenticatable'
require 'jwt'

module Devise
  module Strategies
    class JwtAuthenticatable < Authenticatable

      def valid?
        !jwt.nil? && !jwt.empty?
      end

      def authenticate!

        resource = mapping.to.new

        if validate(resource) { valid_jwt? }
          if decode_jwt.nil?
            fail!(:invalid_jwt)
          else

            resource = mapping.to.find_for_jwt_authentication jwt_claims

            if resource.nil?
              return fail!(:invalid_user)
            end

            if resource.persisted?
              return success!(resource)
            end

            fail!(:invalid_user)

          end
        end

      end

      private

      def bearer_token
        pattern = /^Bearer /
        header  = request.headers["Authorization"] # <= env
        header.gsub(pattern, '') if header && header.match(pattern)
      end

      def jwt

        if params[:jwt]
          return  params[:jwt]
        end

        if  !bearer_token.nil? && !bearer_token.empty?
          return bearer_token
        end

        nil

      end

      def jwt_claims

        jwt = decode_jwt

        if jwt.nil?
          nil
        else
          jwt[0]
        end

      end

      def decode_jwt

        resource = mapping.to

        verify_iat = resource.verify_iat.nil? ? ::Devise.verify_iat : resource.verify_iat
        verify_aud = resource.verify_iat.nil? ? ::Devise.verify_iat : resource.verify_iat
        verify_iss = resource.verify_iss.nil? ? ::Devise.verify_iss : resource.verify_iss
        jwt_secret = resource.jwt_secret || ::Devise.jwt_secret
        jwt_issuer = resource.jwt_issuer || ::Devise.jwt_issuer
        jwt_audience = resource.jwt_audience || ::Devise.jwt_audience

        begin
          decoded_token = JWT.decode jwt, jwt_secret, true, { :verify_iat => verify_iat, :iss => jwt_issuer, :verify_iss => verify_iss, :aud => jwt_audience, :verify_aud => verify_aud, :algorithm => 'HS256'}
        rescue JWT::ExpiredSignature
          Rails.logger.info('Expired Signature')
          return nil
        rescue JWT::InvalidIssuerError
          Rails.logger.info('Invalid Issuer Error')
          return nil
        rescue JWT::InvalidAudError
          Rails.logger.info('Invalid Audience')
          return nil
        rescue JWT::InvalidIatError
          Rails.logger.info('Invalid issued at')
          return nil
        rescue JWT::VerificationError
          Rails.logger.info('Signature Verification error')
          return nil
        end

        decoded_token

      end

      def valid_jwt?

        if decode_jwt.nil?
          return nil
        end

        true

      end

    end
  end
end

Warden::Strategies.add(:jwt_authenticatable, Devise::Strategies::JwtAuthenticatable)
