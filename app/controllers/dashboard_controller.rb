class DashboardController < ApplicationController

  def index
    redirect_to projects_url if user_signed_in?
  end

end
