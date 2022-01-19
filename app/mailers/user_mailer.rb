class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @project = params[:project]
    mail(to: @user.email, subject: "Welcome to #{@project.name} Puzzle")
  end

  def assigned_to_task
    @user = params[:user]
    @task = params[:task]
    @assigner = params[:assigner]
    mail(to: @user.email, subject: "You have been assigned to a new task")
  end
end
