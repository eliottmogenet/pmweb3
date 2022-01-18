class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @project = params[:project]
    mail(to: @user.email, subject: 'Welcome to GetPuzzle!')
  end
end
