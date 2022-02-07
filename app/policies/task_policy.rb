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
    record.public? && record.user.nil? && (record.topic.can_assign_task || user == record.project.user )
  end

  def mark_as_public?
    record.private? && record.creator == user
  end

  def assign?
    record.public? && record.user.nil? && (record.topic.can_assign_task || user == record.project.user )
  end

  def mark_as_done?
    record.ongoing? && (user == record.user || user == record.project.user || user == record.creator)
  end

  def archive?
    !record.archived? && (user == record.creator || user == record.project.user)
  end
end
