class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index]
  before_action :configure_permitted_parameters, if: :devise_controller?

  #def after_sign_up_path_for(resource)
    #@project = Project.find(params[:id])

    #if @project.present?
      #@resource.project_users.create(project: @project)
     #project_tasks_path(@project, puzzle: true)
    #else
      #redirect_to new_project_path
    #end
  #end

  def after_sign_in_path_for(resource)
    @project = Project.find(params[:id])

    if @project
      resource.project_users.create(project: @project)
      project_tasks_path(@project, puzzle: true)
    elsif session[:redirect_url]
      url = session[:redirect_url]
      session[:redirect_url] = nil
      url
    end

  #def after_sign_in_path_for(resource)
    #@project = current_user.projects.first
    #@project = Project.find_by(uuid: session[:project_uuid])

    #project_tasks_path(@project, puzzle: true)
  #end

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :pseudo])
  end
end
