class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :creator, class_name: "User"
  belongs_to :topic, optional: true
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user
  #belongs_to :project, through: :topic

  validates :title, presence: true
  validates_length_of :title, :maximum => 100, :message => "Task title is too long"

  scope :is_private, -> { where(confidentiality: "Private") }
  scope :assigned_to_me, ->(user_id) { where(user_id: user_id) }
  scope :unassigned, -> { where(user_id: nil) }
  scope :by_topic, ->(topic_id) { where(topic_id: topic_id) }
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

  def archived?
    status == "archive"
  end

  def was_upvoted_by(user)
    self.voters.include? user
  end

  private

  def notify_project_members
    NewTaskNotification.with(task: self).deliver(self.project.all_users_except(self.creator))
  end
end
