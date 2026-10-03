class ApplicationController < ActionController::Base
  include Clerk::Authenticatable

  helper_method :clerk_signed_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def clerk_signed_in?
    clerk.session.present?
  end

  def require_clerk_session!
    return if clerk_signed_in?

    redirect_to clerk.sign_in_url, allow_other_host: true
  end
end
