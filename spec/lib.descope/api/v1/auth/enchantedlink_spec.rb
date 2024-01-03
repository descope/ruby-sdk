# frozen_string_literal: true

require 'spec_helper'

describe Descope::Api::V1::EnhancedLink do
  before(:all) do
    dummy_instance = DummyClass.new
    dummy_instance.extend(Descope::Api::V1::Session)
    dummy_instance.extend(Descope::Api::V1::Auth::EnhancedLink)
    @instance = dummy_instance
  end

  context '.sign_in' do
    it 'is expected to respond to sign in' do
      expect(@instance).to respond_to(:enchanted_link_sign_in)
    end

    it 'is expected to sign in with enchanted link' do
      request_params = {
        loginId: 'test',
        URI: 'https://some-uri/email',
        loginOptions: { 'abc': '123' }
      }
      expect(@instance).to receive(:post).with(
        compose_signin_uri,
        request_params,
        nil,
        'refresh_token'
      )

      expect do
        @instance.enchanted_link_sign_in(
          login_id: 'test',
          uri: 'https://some-uri/email',
          login_options: { 'abc': '123' },
          refresh_token: 'refresh_token'
        )
      end.not_to raise_error
    end

    it 'is expected to validate refresh token and not raise an error with refresh token and valid login options' do
      expect do
        @instance.send(:validate_refresh_token_provided,
                       login_options: { mfa: true, stepup: true },
                       refresh_token: 'some-token')
      end.not_to raise_error
    end

    it 'is expected to validate refresh token and raise an error with refresh token and invalid login options' do
      expect do
        @instance.send(:validate_refresh_token_provided,
                       login_options: { 'mfa': true, 'stepup': true },
                       refresh_token: '')
      end.to raise_error(Descope::AuthException, 'Missing refresh token for stepup/mfa')
    end
  end

  context '.sign_up' do
    it 'is expected to respond to sign up' do
      expect(@instance).to respond_to(:enchanted_link_sign_up)
    end

    it 'is expected to sign up with enchanted link' do
      request_params = {
        loginId: 'test',
        URI: 'https://some-uri/email',
        user: { username: 'user1', email: 'dummy@dummy.com' },
        email: 'dummy@dummy.com'
      }

      expect(@instance).to receive(:post).with(
        compose_signup_uri,
        request_params
      )

      expect do
        @instance.enchanted_link_sign_up(
          login_id: 'test',
          uri: 'https://some-uri/email',
          user: { username: 'user1', email: 'dummy@dummy.com' }
        )
      end.not_to raise_error
    end
  end
end
