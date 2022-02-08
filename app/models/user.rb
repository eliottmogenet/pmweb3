class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         :omniauth_providers => [:discord, :developer]

  # belongs_to :employer
  has_many :tasks, dependent: :destroy
  has_many :votes
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :notifications, as: :recipient
  has_many :user_topics, dependent: :destroy
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.photo.attach(io: URI.open(auth.info.image), filename: "#{auth.info.name}.png")
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.pseudo = auth.info.name
    end
  end
end
