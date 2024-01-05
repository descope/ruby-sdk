# frozen_string_literal: true

module Descope
  module Api
    module V1
      module Auth
        # Holds all the password API calls
        module OAuth
          include Descope::Mixins::Validation
          include Descope::Mixins::Common::EndpointsV1
          include Descope::Mixins::Common::EndpointsV2

          def oauth_start(provider: nil, return_url: nil, login_options: nil, refresh_token: nil)
            verify_provider(provider)
            request_params = compose_start_params(provider:, return_url:, login_options:)
            post(OAUTH_START_PATH, request_params, {}, refresh_token)
          end

          def oauth_exchange_token(code = nil)
            exchange_token(code, OAUTH_EXCHANGE_TOKEN_PATH)
          end

          def oauth_create_redirect_url_for_sign_in_request(stepup: false, custom_claims: {}, mfa: false, sso_app_id: nil)
            request_params = {
              stepup:,
              customClaims: custom_claims,
              mfa:,
              ssoAppId: sso_app_id
            }
            post(OAUTH_CREATE_REDIRECT_URL_FOR_SIGN_IN_REQUEST_PATH, request_params)
          end

          def oauth_create_redirect_url_for_sign_up_request(stepup: false, custom_claims: {}, mfa: false, sso_app_id: nil)
            request_params = {
              stepup:,
              customClaims: custom_claims,
              mfa:,
              ssoAppId: sso_app_id
            }
            post(OAUTH_CREATE_REDIRECT_URL_FOR_SIGN_UP_REQUEST_PATH, request_params)
          end

          private

          def compose_start_params(provider: nil, return_url: nil, login_options: nil)
            login_options ||= {}

            unless login_options.is_a?(Hash)
              raise Descope::ArgumentException.new(
                'Unable to read login_options, not a Hash',
                code: 400
              )
            end

            request_params = { provider: }
            request_params[:returnUrl] = return_url if return_url
            request_params[:stepup] = login_options.fetch(:stepup, false)
            request_params[:mfa] = login_options.fetch(:mfa, false)
            request_params[:customClaims] = login_options.fetch(:custom_claims, {})
            request_params[:ssoAppId] = login_options.fetch(:sso_app_id, nil)
            request_params
          end
        end
      end
    end
  end
end
