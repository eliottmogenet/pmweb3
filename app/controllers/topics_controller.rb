class TopicsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @topic = Topic.new(topic_params)
    @topic.project = @project

    authorize @topic

    @topic.save!
    redirect_to project_tasks_path(@project, by_topic: @topic.id) #+topic scope selected
  end

  def reset_time
    @topic_selected = Topic.find(params[:id])
    @project = @topic_selected.project

    authorize @topic_selected

    @topic_selected.date = nil

    if @topic_selected.save
      respond_to do |format|
        format.html
        format.text { render partial: "tasks/timer", locals: {project: @project, topic_selected: @topic_selected}, formats: [:html] }
      end
    end
  end

  def update
    @topic_selected = Topic.find(params[:id])
    @project = Project.find(params[:project_id])
    @previous_date = @topic_selected.date

    authorize @topic_selected

    @topic_selected.update(topic_params)

        if @previous_date == @topic_selected.date
          redirect_to project_tasks_path(@project, by_topic: @topic_selected.id)
        else
          @date = TimeDifference.between(@topic_selected.date, Time.now).in_general

          respond_to do |format|
          format.html
          format.text { render partial: "tasks/timer", locals: {project: @project, topic_selected: @topic_selected, date: @date}, formats: [:html] }
        end
      end
    end

  private

  def topic_params
     params.require(:topic).permit(:name, :rules, :description, :can_create_task, :can_assign_task, :can_vote, :infinite, :project_id, :date)
  end
end
