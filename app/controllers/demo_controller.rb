class DemoController < ApplicationController
  before_action :require_clerk_session!

  def index
    @user = clerk.user
  end
end
