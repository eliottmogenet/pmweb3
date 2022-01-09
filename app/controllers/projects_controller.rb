class ProjectsController < ApplicationController
  def index
    @employer = Employer.find(params[:employer_id])
    @projects = Project.where(employer_id: @employer)
    @project = Project.new
  end

  def show
    @employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:id])
    @task = Task.new

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
        redirect_to employer_projects_path(@employer)
      else
        redirect_to employer_projects_path(@employer)
      end
  end

  def update
    @employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:id])
    @project.update(project_params)
    redirect_to employer_project_path(@employer, @project)
  end

  def reset_time
    @employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:id])
    @project.date = nil
    @project.save!
    redirect_to employer_project_path(@employer, @project)
  end

  private

  def project_params
    params.require(:project).permit(:name, :date)
  end
end
