class TopicPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.project.user == user
  end

  def update?
    record.project.user == user
  end

  def reset_time?
    record.project.user == user
  end

  def feedback_template?
    true
  end

  def twitter_template?
    true
  end


  def moderator_template?
    true
  end


  def referral_template?
    true
  end
end
