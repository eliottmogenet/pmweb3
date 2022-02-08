class UserTopicsController < ApplicationController
	skip_before_action :authenticate_user!

	def create
		@user_topic = UserTopic.new
		@topic = Topic.find(params[:topic_id])
		@user_topic.topic = @topic

		authorize @user_topic

		if user_signed_in?
			@user_topic.user = current_user
		else
			@user_topic.user_ip = request.remote_ip
		end

		@user_topic.save

		respond_to do |format|
			format.html
			format.text
		end
	end 
end
