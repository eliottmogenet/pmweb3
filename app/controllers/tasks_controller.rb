class TasksController < ApplicationController
  def create
    @employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:project_id])
    @task = Task.new(task_params)
    @task.project = @project
    @task.save!
    redirect_to employer_project_path(@employer, @project)
  end

  def update
    @employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @task.project = @project
    @task.update(task_params)
    redirect_to employer_project_path(@employer, @project)
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :token_number, :user_id)
  end
end
