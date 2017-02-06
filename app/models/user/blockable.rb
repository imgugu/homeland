class User
  module Blockable
    extend ActiveSupport::Concern

    def block_users?
      block_user_actions.count > 0
    end

    def block_user?(user)
      uid = user.is_a?(User) ? user.id : user
      block_user_ids.include?(uid)
    end
  end
end
