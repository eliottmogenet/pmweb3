# To deliver this notification:
#
# TaskNotification.with(post: @post).deliver_later(current_user)
# TaskNotification.with(post: @post).deliver(current_user)

class NewTaskNotification < Noticed::Base
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"

  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :task

  # Define helper methods to make rendering easier.
  #
  def message
    "A new task has been created !"
  end

  def url
    project_tasks_path(Task.find(params[:task]).project, puzzle: true)
  end
end
