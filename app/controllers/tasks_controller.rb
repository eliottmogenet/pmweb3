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
    @task.confidentiality = "Private"

    if @task.save
      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project) }
        format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
      end
    end      
  end

  def update
    @task = Task.find(params[:id])
    @project = @task.project

    if @task.update(task_params)
      @topics = @project.tasks.pluck(:topic).uniq.reject(&:blank?)
      
      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.json do 
          render json: {
            partial: render_to_string(partial: "tasks/task", locals: {task: @task}, formats: [:html]),
            filters: render_to_string(partial: "tasks/filters", locals: {project: @project, topics: @topics}, formats: [:html]),
            total: @project.tasks.pluck(:token_number).map(&:to_i).sum, 
          }.to_json
        end
      end
    end
  end

  def mark_as_public
    @task = Task.find(params[:id])
    @project = @task.project
    
    if @task.update(confidentiality: "Public")
      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
      end
    end
  end

  def mark_as_done
    @task = Task.find(params[:id])
    @project = @task.project
    
    if @task.update(status: "claimed")
      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        # format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
        format.json do 
          render json: {
            partial: render_to_string(partial: "tasks/task", locals: {task: @task}, formats: [:html]),
            subtotal: @project.tasks.where(status: "claimed").pluck(:token_number).map(&:to_i).sum,
            usertotal: current_user.tasks.where(status: "claimed").pluck(:token_number).map(&:to_i).sum
          }.to_json
        end
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :status, :token_number, :user_id, :creator_id, :confidentiality, :description, :topic)
  end
end
