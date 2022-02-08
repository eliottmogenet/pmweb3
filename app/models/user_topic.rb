class UserTopic < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :topic
end
