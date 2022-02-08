class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    render text: request.env['omniauth.auth'].to_yaml
  end
end
