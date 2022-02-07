class TopicsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @topic = Topic.new(topic_params)
    @topic.project = @project

    authorize @topic

    @topic.save!
    redirect_to project_tasks_path(@project, by_topic: @topic.id) #+topic scope selected
  end

  def update
    @topic_selected = Topic.find(params[:id])
    @topic_selected.update(topic_params)
    @topic_selected.save!
  end

  private

  def topic_params
     params.require(:topic).permit(:name, :rules, :description, :can_create_task, :can_assign_task, :can_vote, :infinite, :project_id, :date)
  end
end
