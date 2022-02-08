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
end
