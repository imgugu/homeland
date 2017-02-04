# Auto generate with actionstore gem.
class Action < ActiveRecord::Base
  include ActionStore::Model

  # Action for Topic
  action_for :like, :topic, counter_cache: true
  action_for :favorite, :topic
  action_for :follow, :topic

  # Action for Reply
  action_for :like, :reply, counter_cache: true

  # Action for User
  action_for :follow, :user, counter_cache: 'followers_count',
                             user_counter_cache: 'following_count'
  action_for :block, :user

  # Action for Node
  action_for :block, :node
end