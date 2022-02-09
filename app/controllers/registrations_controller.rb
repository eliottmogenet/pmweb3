class RegistrationsController < Devise::RegistrationsController
  def new
    session[:project_uuid] = params[:project_uuid]
  	@project = Project.find_by(uuid: params[:project_uuid])
    super
  end

  def create
  	@project = Project.find_by(uuid: params[:project_uuid])
  	build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
    	resource.project_users.create(project: @project) if @project
      #UserMailer.with(user: resource, project: @project).welcome.deliver_now
      if resource.active_for_authentication?
        #flash[:notice] = "Welcome! You have signed up and joined #{@project.name}'s Puzzle successfully."
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @project = current_user.projects.first
    @user.update(user_params)
    redirect_to project_tasks_path(@project, puzzle: true)
  end

  private

  def after_sign_up_path_for(resource)
    if @project
      project_tasks_path(@project, puzzle: true)
    elsif session[:redirect_url]
      url = session[:redirect_url]
      session[:redirect_url] = nil
      url
    else
      new_project_path
    end
  end

  def user_params
      params.require(:user).permit(:name, :email, :password, :pseudo, :photo,
                                   :password_confirmation)
  end
end
