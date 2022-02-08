class ProjectsController < ApplicationController
  has_scope :private_filter, type: :boolean
  skip_before_action :authenticate_user!, only: [:join]
  before_action :set_project_by_uuid, only: [:join]
  before_action :verify_authenticated_user!, only: [:join]
  # method index has been comment because index is not display so far

  # def index
    # @employer = current_user.employer
      # @projects = Project.where(employer_id: @employer)
        # @project = Project.new
    # end
  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project_user = ProjectUser.new
    @project_user.project = @project
    @project_user.user = current_user
    @project_user.save

    @project.save
    if @project.save
      redirect_to edit_project_path(@project)
    else
      redirect_to new_project_path
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def show
    @employer = current_user.employer
    @project = current_user.projects.first
    @task = Task.new
      if @project.tasks != nil
        @assigned_tasks = @project.tasks.where.not('user_id' => nil)
        #@tasks_by_status = apply_scopes(Task).where(status: @task.status).load
      end

      if @project.date.nil? == false
        @date = TimeDifference.between(@project.date, Time.now).in_general
      end
  end

  #def create
    #@employer = Employer.find(params[:employer_id])
    #@project = Project.new(project_params)
    #@project.employer = @employer
    #@project.user = current_user
      #if @project.save
        #redirect_to projects_path
      #else
        #redirect_to projects_path
      #end
  #end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    redirect_to project_tasks_path(@project)
  end


  def join_puzzle
    @project =  Project.find(params[:id])
    @project_user = ProjectUser.new
    @project_user.project = @project
    @project_user.user = current_user
    @project_user.save
    redirect_to project_tasks_path(@project)
  end

  def join
    if user_signed_in? && current_user.projects.include?(@project)
      flash[:notice] = "You already joined #{@project.name}'s Puzzle"
      redirect_to project_tasks_path(@project)
    else
      flash[:alert] = "You cannot join two projects (yet)..."
      redirect_to project_tasks_path(current_user.projects.first)
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :date, :user_id, :description, :txt_color, :date, :uui, :background)
  end

  def project_users_params
    params.require(:project_user).permit(:user_id, :project_id)
  end

  def set_project_by_uuid
    @project = Project.find_by(uuid: params[:uuid])
  end

  def verify_authenticated_user!
    redirect_to new_user_registration_path(project_uuid: @project.uuid) unless user_signed_in?
  end
end
