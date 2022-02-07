class Project < ApplicationRecord
  #belongs_to :employer
  belongs_to :user

  has_many :tasks
  has_many :topics
  has_many :project_users
  has_many :users, through: :project_users
  has_one_attached :logo
  has_one_attached :background


  after_create :set_uuid

  validates :name, presence: true

  def public_or_own_tasks(user)
    [tasks.where(confidentiality: "Public"), tasks.where(creator: user)].flatten.uniq
  end

  def public_tasks
    tasks.where(confidentiality: "Public")
  end

  def all_users_except(user)
    users.where.not(id: user.id)
  end

  def set_uuid
    self.update(uuid: SecureRandom.hex(10))
  end
end
