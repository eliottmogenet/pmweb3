class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # belongs_to :employer
  has_many :tasks
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :notifications, as: :recipient
  has_one_attached :photo

  validate :has_pseudo_or_name

  def has_pseudo_or_name
    if pseudo.blank? && (first_name.blank? && last_name.blank?)
      errors.add(:pseudo, "and name can't be both blank")
    end
  end

  def has_notifications_for(task)
    notifications.map(&:to_notification).find { |notif| notif.unread? && notif.params[:task] == task } if notifications.any?
  end

  def has_topic_notifications_for(topic)
    notifications.map(&:to_notification).find { |notif| notif.unread? && !notif.params[:task].private? && notif.params[:task].topic == topic } if notifications.any?
  end

  def full_name
    if pseudo.present?
      pseudo
    else
      "#{first_name.capitalize} #{last_name.capitalize}"
    end
  end
end
