class ProjectsController < ApplicationController
  has_scope :private_filter, type: :boolean
  skip_before_action :authenticate_user!, only: [:join]
  before_action :set_project_by_uuid, only: [:join]
  before_action :verify_authenticated_user!, only: [:join]
  # method index has been comment because index is not display so far

  # def index
    # @employer = current_user.employer
      # @projects = Project.where(employer_id: @employer)
        # @project = Project.new
    # end
  def new
    @project = Project.new

    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    @project.user = current_user
    @project_user = ProjectUser.new
    @project_user.project = @project
    @project_user.user = current_user
    @project_user.save

    @project.save
    if @project.save
      redirect_to edit_project_path(@project)
    else
      redirect_to new_project_path
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def show
    @employer = current_user.employer
    @project = current_user.projects.first
    authorize @project

    @task = Task.new
      if @project.tasks != nil
        @assigned_tasks = @project.tasks.where.not('user_id' => nil)
        #@tasks_by_status = apply_scopes(Task).where(status: @task.status).load
      end

      if @project.date.nil? == false
        @date = TimeDifference.between(@project.date, Time.now).in_general
      end
  end

  #def create
    #@employer = Employer.find(params[:employer_id])
    #@project = Project.new(project_params)
    #@project.employer = @employer
    #@project.user = current_user
      #if @project.save
        #redirect_to projects_path
      #else
        #redirect_to projects_path
      #end
  #end

  def update
    @project = Project.find(params[:id])
    authorize @project

    if @project.update(project_params)
      redirect_to project_tasks_path(@project, puzzle: true)
    else
      redirect_to edit_project_path(@project)
    end
  end


  def join_puzzle
    @project =  Project.find(params[:id])
    authorize @project

    @project_user = ProjectUser.new
    @project_user.project = @project
    @project_user.user = current_user
    @project_user.save
    redirect_to project_tasks_path(@project, puzzle: true)
  end

  def join
    authorize @project

    if user_signed_in? && current_user.projects.include?(@project)
      flash[:notice] = "You already joined #{@project.name}'s Puzzle"
      redirect_to project_tasks_path(@project, puzzle: true)
    else
      flash[:alert] = "You cannot join two projects (yet)..."
      redirect_to project_tasks_path(current_user.projects.first, puzzle: true)
    end
  end

  #topic template creation

 def feedback_template
    @project = Project.find(params[:id])
    authorize @project

    @topic = Topic.new(name: "Feedbacks", description: "Give any feedback about #{@project.name} and vote by adding Puzzle pieces.", rules:"
1. Submit an idea/feedback.

2. Vote by adding +1 on your favorite ideas/feedbacks

3. #{@project.name} team will implement the ideas with the most votes.")
    authorize @topic
    @topic.project = @project
    @topic.can_create_task = true
    @topic.can_vote = true
    @topic.save!

    redirect_to project_tasks_path(@project, by_topic: @topic.id)
  end

  def twitter_template
    @project = Project.find(params[:id])
    authorize @project

    @topic = Topic.new(name: "Twitter", description: "Help kickoff #{@project.name} community on Twitter by posting.", rules: "
1. Assign yourself to a Twitter post.

2. Publish the post and send the link to @#{@project.user.pseudo} on Discord.

3. Mark as done and win the Puzzle pieces!")
    authorize @topic
    @topic.project = @project
    @topic.save!


    @task1 = Task.new(title: "3/3 Post on twitter about #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task1.project = @project
    authorize @task1
    @task1.save!

    @task2 = Task.new(title: "2/3 Post on twitter about #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task2.project = @project
    authorize @task2
    @task2.save!

    @task3 = Task.new(title: "1/3 Post on twitter about #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task3.project = @project
    authorize @task3
    @task3.save!

    redirect_to project_tasks_path(@project, by_topic: @topic.id)
  end


  def moderator_template
    @project = Project.find(params[:id])
    authorize @project

    @topic = Topic.new(name: "Moderators", description: "Here the space for organizing #{@project.name} moderators", rules: "
1. Assign yourself to the tasks you want to do.

2. Make the tasks before the time ends.

3. Once done, mark as done to claim the rewards.")
    authorize @topic
    @topic.project = @project
    @topic.can_create_task = true
    @topic.save!

    redirect_to project_tasks_path(@project, by_topic: @topic.id)
  end


  def referral_template
    @project = Project.find(params[:id])
    authorize @project

    @topic = Topic.new(name: "Referrals", description: "Refer your friends to #{@project.name} and win puzzle pieces", rules: "
1. Assign yourself to a referral task.

2. Ask your friend to mention your name to the Discord moderator when subscribing to #{@project.name}.

3. Once your friend entered, you will win the Puzzle pieces!")
    authorize @topic
    @topic.project = @project
    @topic.save!

    @task1 = Task.new(title: "3/3 Refer to #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task1.project = @project
    authorize @task1
    @task1.save!

    @task2 = Task.new(title: "2/3 Refer to #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task2.project = @project
    authorize @task2
    @task2.save!

    @task3 = Task.new(title: "1/3 Refer to #{@project.name}", token_number: "2", creator_id: current_user.id, confidentiality: "Public", topic_id: @topic.id)
    @task3.project = @project
    authorize @task3
    @task3.save!

    redirect_to project_tasks_path(@project, by_topic: @topic.id)
  end

  private

  def project_params
    params.require(:project).permit(:name, :date, :user_id, :description, :txt_color, :date, :uui, :background)
  end

  def project_users_params
    params.require(:project_user).permit(:user_id, :project_id)
  end

  def set_project_by_uuid
    @project = Project.find_by(uuid: params[:uuid])
  end

  def verify_authenticated_user!
    redirect_to new_user_registration_path(project_uuid: @project.uuid) unless user_signed_in?
  end
end
