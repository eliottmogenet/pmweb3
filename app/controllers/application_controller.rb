class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    @user = current_user
    @employer = @user.employer
      employer_projects_path(@employer)
  end
end
