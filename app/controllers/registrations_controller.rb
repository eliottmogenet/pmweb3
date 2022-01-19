class RegistrationsController < Devise::RegistrationsController
  def new
  	@project = Project.find_by(uuid: params[:project_uuid])
    super
  end

  def create
  	@project = Project.find_by(uuid: params[:project_uuid])
  	build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
    	resource.project_users.create(project: @project)
      UserMailer.with(user: resource, project: @project).welcome.deliver_now
      if resource.active_for_authentication?
        flash[:notice] = "Welcome! You have signed up and joined #{@project.name}'s Puzzle successfully."
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

  def update
    super
  end
end 
