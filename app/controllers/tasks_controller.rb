class TasksController < ApplicationController
  def create
    @employer = Project.find(params[:employer_id])
    @project = Project.find(params[:project_id])
    @task = Task.new(task_params)
    @task.project = @project
    @task.save!
    redirect_to employer_project_path(@employer, @project)
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :token_number)
  end
end
