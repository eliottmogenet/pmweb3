class Project < ApplicationRecord
  has_many :tasks
  belongs_to :employer
  belongs_to :user
  has_many :project_users
  has_many :users, through: :project_users

  def all_users_except(user)
    users.where.not(id: user.id)
  end

  after_create :set_uuid

  validates :name, presence: true

  def set_uuid
    self.update(uuid: SecureRandom.hex(10))
  end
end
