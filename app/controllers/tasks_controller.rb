class TasksController < ApplicationController
  has_scope :is_private, type: :boolean
  has_scope :assigned_to_me
  has_scope :unassigned, type: :boolean
  has_scope :by_topic
  has_scope :ongoing, type: :boolean
  has_scope :done, type: :boolean

  def index
    @employer = current_user.employer
    @project = current_user.projects.first
    @task = Task.new
    @tasks = apply_scopes(Task).all
    @topics = @project.tasks.pluck(:topic).uniq.reject(&:blank?)

    respond_to do |format|
      format.html
      format.text { render partial: "tasks/list", locals: { tasks: @tasks }, formats: [:html] }
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
