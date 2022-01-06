class Project < ApplicationRecord
  has_many :tasks
  belongs_to :employer
  belongs_to :user
  has_many :users, through: :tasks
end
