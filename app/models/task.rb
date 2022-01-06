class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  validates :title, presence: true
  validates_length_of :title, :maximum => 100, :message => "Task title is too long"
end
