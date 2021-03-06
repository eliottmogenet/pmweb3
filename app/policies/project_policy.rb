class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    true
  end

  def join?
    true
  end

  def join_puzzle?
    true
  end

  def show?
    true
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
