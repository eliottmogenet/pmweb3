class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :creator, class_name: "User"

  validates :title, presence: true
  validates_length_of :title, :maximum => 100, :message => "Task title is too long"

  scope :is_private, -> { where(confidentiality: "Private") }
  scope :assigned_to_me, ->(user_id) { where(user_id: user_id) }
  scope :unassigned, -> { where(user_id: nil) }
  scope :by_topic, ->(topic) { where(topic: topic) }
  scope :ongoing, -> { where(status: "ongoing") }
  scope :done, -> { where(status: "claimed") }

  after_create_commit :notify_project_members

  def private?
    confidentiality == "Private"
  end

  def public?
    confidentiality == "Public"
  end

  def ongoing?
    status == "ongoing"
  end

  private

  def notify_project_members
    NewTaskNotification.with(task: self).deliver(self.project.all_users_except(self.creator))
  end
end
