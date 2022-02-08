class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  
  def home
  end

  def reload
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end
end
