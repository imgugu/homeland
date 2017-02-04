class User
  module Blockable
    extend ActiveSupport::Concern

    included do
      has_many :blocked_node_actions, -> { where(action_type: 'block', target_type: 'Node') }, class_name: "Action"
      has_many :blocked_nodes, through: :blocked_node_actions, source: :target, source_type: 'Node'

      has_many :blocked_user_actions, -> { where(action_type: 'block', target_type: 'User') }, class_name: "Action"
      has_many :blocked_users, through: :blocked_user_actions, source: :target, source_type: 'User'
    end

    def blocked_node_ids
      @blocked_node_ids ||= blocked_node_actions.collect(&:target_id)
    end

    def block_node(node_id)
      Action.create_action(:block, target_type: 'Node', target_id: node_id, user: self)
    end

    def unblock_node(node_id)
      Action.destroy_action(:block, target_type: 'Node', target_id: node_id, user: self)
    end

    def blocked_user_ids
      @blocked_user_ids ||= blocked_user_actions.collect(&:target_id)
    end

    def blocked_users?
      blocked_user_actions.count > 0
    end

    def blocked_user?(user)
      uid = user.is_a?(User) ? user.id : user
      blocked_user_ids.include?(uid)
    end

    def block_user(user_id)
      Action.create_action(:block, target_type: 'User', target_id: user_id, user: self)
    end

    def unblock_user(user_id)
      Action.destroy_action(:block, target_type: 'User', target_id: user_id, user: self)
    end
  end
end
