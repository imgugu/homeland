class User
  module TopicFavorate
    extend ActiveSupport::Concern

    included do
      has_many :favorite_topic_actions, -> { where(action_type: 'favorite', target_type: 'Topic') }, class_name: "Action"
      has_many :favorite_topics, through: :favorite_topic_actions, source: :target, source_type: 'Topic'
    end

    # 收藏话题
    def favorite_topic(topic_id)
      Action.create_action(:favorite, target_type: 'Topic', topic_id: topic_id, user: self)
    end

    # 取消对话题的收藏
    def unfavorite_topic(topic_id)
      Action.destroy_action(:favorite, target_type: 'Topic', topic_id: topic_id, user: self)
    end

    # 是否收藏过话题
    def favorited_topic?(topic_id)
      Action.find_action(:favorite, target_type: 'Topic', topic_id: topic_id, user: self).present?
    end

    def favorite_topics_count
      favorite_topic_actions.count
    end
    alias favorites_count favorite_topics_count
  end
end
