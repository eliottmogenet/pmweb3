class TasksController < ApplicationController

  def index
    @employer = current_user.employer
    @project = current_user.projects.first
    @task = Task.new
    @filtered_tasks = @project.tasks

#params for filters

    if params[:status]
      @filtered_tasks = @project.tasks.where(:status => params[:status])
    elsif params[:confidentiality]
      @filtered_tasks = @project.tasks.where(:confidentiality => params[:confidentiality])
    elsif params[:user_id]
      @filtered_tasks = @project.tasks.where(:user_id => params[:user_id])
    elsif params[:topic]
      @filtered_tasks = @project.tasks.where(:topic => params[:topic])
    else
      @project.tasks = Task.all
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @task = Task.new(task_params)
    @task.project = @project
    @task.creator = current_user
    @task.confidentiality = "Private" #when a user create a task, it's private
    if @task.save
      redirect_to project_tasks_path(@project)
    else
      redirect_to project_tasks_path(@project)
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @task.project = @project
    @task.update(task_params)
    redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}")
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :token_number, :user_id, :creator_id, :confidentiality, :description, :topic)
  end
end
