class AuthController < ApplicationController
  def sign_in
    redirect_to clerk_credentials.fetch(:sign_in_url),
                allow_other_host: true
  end

  def sign_up
    redirect_to clerk_credentials.fetch(:sign_up_url),
                allow_other_host: true
  end

  private

  def clerk_credentials
    Rails.application.credentials.clerk
  end
end
