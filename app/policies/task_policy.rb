class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.topic&.can_create_task || record.project.user == user
  end

  def update?
    user && user == record.project.user || user == record.creator
  end

  def set_tokens?
    user && user == record.project.user || user == record.creator
  end

  def mark_as_public?
    user && record.private? && record.creator == user
  end

  def assign?
    user && record.public? && record.user.nil? && (record.topic.can_assign_task || user == record.project.user )
  end

  def mark_as_done?
    user && record.ongoing? && (user == record.user || user == record.project.user || user == record.creator)
  end

  def archive?
    user && !record.archived? && (user == record.creator || user == record.project.user || user == record.user)
  end

  def vote?
    user && record.topic.can_vote
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
