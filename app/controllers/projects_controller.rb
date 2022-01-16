class ProjectsController < ApplicationController
  has_scope :private_filter, type: :boolean
  # method index has been comment because index is not display so far

  # def index
    # @employer = current_user.employer
      # @projects = Project.where(employer_id: @employer)
        # @project = Project.new
    # end

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

  def create
    @employer = Employer.find(params[:employer_id])
    @project = Project.new(project_params)
    @project.employer = @employer
    @project.user = current_user
      if @project.save
        redirect_to projects_path
      else
        redirect_to projects_path
      end
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    redirect_to project_tasks_path(@project)
  end

  def reset_time
    @project = Project.find(params[:id])
    @project.date = nil
    @project.save!
    redirect_to project_tasks_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(:name, :date)
  end
end
