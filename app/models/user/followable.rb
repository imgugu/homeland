class User
  module Followable
    extend ActiveSupport::Concern

    def followed?(user)
      uid = user.is_a?(User) ? user.id : user
      self.follow_user_ids.include?(uid)
    end

    def follow_user(user)
      return unless user
      Action.create_action(:follow, target: user, user: self)
      Notification.notify_follow(user.id, self.id)
    end
  end
end
