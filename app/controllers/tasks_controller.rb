class TasksController < ApplicationController
  has_scope :unassigned, type: :boolean

  def index
    @employer = current_user.employer
    @project = current_user.projects.first
    @task = Task.new
    @filtered_tasks = @project.tasks

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

      #if @project.tasks != nil
        #@tasks = @project.tasks
        #@assigned_tasks = @project.tasks.where.not('user_id' => nil)
        #@tasks_by_status = apply_scopes(Task).where(status: @task.status).load
      #end


      if @project.date.nil? == false
        @date = TimeDifference.between(@project.date, Time.now).in_general
      end
  end


  def create
    #@employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:project_id])
    @task = Task.new(task_params)
    @task.project = @project
    @task.creator = current_user
    @task.confidentiality = "Private"
    if @task.save
      redirect_to project_tasks_path(@project)
    else
      redirect_to project_tasks_path(@project)
    end
  end

  def update
    #@employer = Employer.find(params[:employer_id])
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @task.project = @project
    @task.update(task_params)
    redirect_to project_tasks_path(@project, anchor: "task-#{@task.id}")
  end

  def show
    @task = Task.find(params[:id])
    @project = @task.project
  end



  private

  def task_params
    params.require(:task).permit(:title, :status, :token_number, :user_id, :creator_id, :confidentiality, :description, :topic)
  end
end
