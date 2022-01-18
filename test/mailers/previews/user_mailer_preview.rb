# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    user = User.find(34)
    project = user.project
    # This is how you pass value to params[:user] inside mailer definition!
    UserMailer.with(user: user, project: project).welcome
  end
end
