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
  end

  def create
    @employer = Employer.find(params[:employer_id])
    @project = Project.new(project_params)
    @project.employer = @employer
    @project.user = User.first
    @project.save!
    redirect_to employer_projects_path(@employer)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
