class Project < ApplicationRecord

  has_many :tasks
  belongs_to :employer
  belongs_to :user
  has_many :project_users
  has_many :users, through: :project_users

  validates :name, presence: true
end
