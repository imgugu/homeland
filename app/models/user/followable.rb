class User
  module Followable
    extend ActiveSupport::Concern

    included do
      has_many :following_actions, -> { where(action_type: 'follow', target_type: 'User') }, class_name: "Action"
      has_many :following, through: :following_actions, source: :target, source_type: 'User'

      has_many :follower_actions, -> { where(action_type: 'follow', target_type: 'User') }, class_name: "Action", foreign_key: 'target_id'
      has_many :followers, through: :follower_actions, source: :user
    end

    def following_ids
      @following_ids ||= following_actions.collect(&:target_id)
    end

    def followers_ids
      @followers_ids ||= follower_actions.collect(&:user_id)
    end

    def followed?(user)
      uid = user.is_a?(User) ? user.id : user
      self.following_ids.include?(uid)
    end

    def follow_user(user)
      return unless user
      Action.create_action(:follow, target: user, user: self)
      Notification.notify_follow(user.id, self.id)
    end

    def unfollow_user(user)
      return unless user
      Action.destroy_action(:follow, target: user, user: self)
    end
  end
end
