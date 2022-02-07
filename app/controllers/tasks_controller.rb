class TasksController < ApplicationController
  has_scope :is_private, type: :boolean
  has_scope :assigned_to_me
  has_scope :unassigned, type: :boolean
  has_scope :by_topic
  has_scope :ongoing, type: :boolean
  has_scope :done, type: :boolean

  def index
    @project = Project.find(params[:project_id])
    @task = Task.new(project: @project)

    @task.topic = Topic.find(params[:by_topic]) if params[:by_topic]
    
    @tasks = apply_scopes(policy_scope(@project.tasks)).reject { |task| (task.private? && task.creator != current_user) || task.archived? }.sort_by {|task| [task.token_number, task.created_at]}.reverse

    @topics = @project.public_or_own_tasks(current_user).pluck(:topic).uniq.reject(&:blank?).sort
    @topic = Topic.new

    if current_user.nil? == false
      @notifications = current_user.notifications
    end

    if params[:by_topic].present?
      @topic_selected = Topic.find(params[:by_topic])
      @notifications.each do |notif|
        notif.update(read_at: Time.now) if notif.to_notification.params[:task].topic == params[:by_topic]
      end

      if @topic_selected.date.nil? == false
        @date = TimeDifference.between(@topic_selected.date, Time.now).in_general
      end
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          partial: render_to_string(partial: "tasks/list", locals: {tasks: @tasks}, formats: [:html]),
          filters: render_to_string(partial: "tasks/filters", locals: {project: @project, topics: @topics}, formats: [:html]),
        }.to_json
      end
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @task = Task.new(task_params)

    @task.project = @project
    @task.creator = current_user
    @task.confidentiality = "Private"

    authorize @task

    if @project.users.exclude?(@task.creator)
      @project_user = ProjectUser.new
      @project_user.project = @project
      @project_user.user = current_user
      @project_user.save
    end

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

    authorize @task

    if @task.update(task_params)
      broadcast_changes

      UserMailer.with(user: @task.user, task: @task, assigner: current_user).assigned_to_task.deliver_now if task_params[:user_id].present?

      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
      end
    end
  end

  def mark_as_public
    @task = Task.find(params[:id])
    @project = @task.project

    authorize @task

    if @task.update(confidentiality: "Public")
      broadcast_changes

      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
      end
    end
  end

  def mark_as_done
    @task = Task.find(params[:id])
    @project = @task.project

    authorize @task

    if @task.update(status: "claimed")
      @topics = @project.tasks.pluck(:topic).uniq.reject(&:blank?).sort
      broadcast_changes

      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.text { render partial: "tasks/task", locals: {task: @task}, formats: [:html] }
      end
    end
  end

  def vote
    #To complete with AJAX method
    @task = Task.find(params[:id])
    @project = @task.project

    @vote = Vote.new(
      task: @task,
      user: current_user
    )

    if @vote.save
      @task.token_number += 1
      @task.save

      @topics = @project.tasks.pluck(:topic).uniq.reject(&:blank?).sort

      ProjectChannel.broadcast_to(
        @project,
        {
          vote: true,
          current_user_id: current_user.id,
          id: @task.id,
          partial: render_to_string(partial: "tasks/task", locals: {task: @task, notify: true}, formats: [:html]),
        }
      )

      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.json { render json: { success: true }.to_json }
      end
    end
  end

  def archive
    @task = Task.find(params[:id])
    @project = @task.project

    if @task.update(status: "archive")
      broadcast_changes

      respond_to do |format|
        format.html { redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}") }
        format.text
      end
    end
  end

  private

  def broadcast_changes
    ProjectChannel.broadcast_to(@project,
      { 
        update: true,
        user_id: current_user.id,
        partial: render_to_string(partial: "shared/flashes", locals: {alert: "outdated"}, formats: [:html])
      }
    )
  end

  def task_params
    params.require(:task).permit(:title, :status, :token_number, :user_id, :creator_id, :confidentiality, :description, :topic_id)
  end
end
