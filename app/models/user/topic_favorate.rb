class User
  module TopicFavorate
    extend ActiveSupport::Concern

    # 是否收藏过话题
    def favorite_topic?(topic_id)
      Action.find_action(:favorite, target_type: 'Topic', topic_id: topic_id, user: self).present?
    end

    def favorites_count
      favorite_topic_actions.count
    end
  end
end
