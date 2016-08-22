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
            fail!(:invalid_user)
          else
            resource = mapping.to.find_or_create_from_jwt_hash decode_jwt
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

      def decode_jwt

        secret = ::Devise.jwt_secret

        begin
          decoded_token = JWT.decode jwt, secret, true, { :verify_iat => ::Devise.verify_iat, :iss => ::Devise.jwt_issuer, :verify_iss => ::Devise.verify_iss, :aud => ::Devise.jwt_audience, :verify_aud => ::Devise.verify_aud, :algorithm => 'HS256'}
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

        decoded_token[0]

      end

      def valid_jwt?
        secret = ::Devise.jwt_secret

        begin
          decoded_token = JWT.decode jwt, secret, true, { :verify_iat => ::Devise.verify_iat, :iss => ::Devise.jwt_issuer, :verify_iss => ::Devise.verify_iss, :aud => ::Devise.jwt_audience, :verify_aud => ::Devise.verify_aud, :algorithm => 'HS256'}
        rescue JWT::ExpiredSignature
          Rails.logger.info('Expired Signature')
          return false
        rescue JWT::InvalidIssuerError
          Rails.logger.info('Invalid Issuer Error')
          return false
        rescue JWT::InvalidAudError
          Rails.logger.info('Invalid Audience')
          return false
        rescue JWT::InvalidIatError
          Rails.logger.info('Invalid issued at')
          return false
        rescue JWT::VerificationError
          Rails.logger.info('Signature Verification error')
          return false
        end

        true
      end

    end
  end
end

Warden::Strategies.add(:jwt_authenticatable, Devise::Strategies::JwtAuthenticatable)
