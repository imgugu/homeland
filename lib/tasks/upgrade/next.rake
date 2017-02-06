namespace :upgrade do
  desc 'Updates the ruby-advisory-db and runs audit'
  task next: :environment do
    # Action.delete_all
    move_data_from_users

    puts "Import User done, Action on #{Action.last.id}"
  end
end

def move_data_from_users
  User.unscoped.where('type is null').find_in_batches do |group|
    group.each do |u|
      Action.bulk_insert(set_size: 100) do |worker|
        # following_ids
        default_action = {
          action_type: 'follow',
          target_type: 'User',
          user_id: u.id
        }
        puts "User:#{u.id} follow users"
        u[:following_ids].each do |uid|
          puts "  Add to: #{uid}"
          action = default_action.merge(target_id: uid)
          worker.add(action)
        end
        u.update_attributes(followers_count: u[:follower_ids].count, following_count: u[:following_ids].count)

        # block_user_ids
        default_action = {
          action_type: 'block',
          target_type: 'User',
          user_id: u.id
        }
        puts "User:#{u.id} block users"
        u[:block_user_ids].each do |uid|
          puts "  Add to: #{uid}"
          action = default_action.merge(target_id: uid)
          worker.add(action)
        end

        # blocked_node_ids
        default_action = {
          action_type: 'block',
          target_type: 'Node',
          user_id: u.id
        }
        puts "User:#{u.id} block users"
        u[:blocked_node_ids].each do |node_id|
          puts "  Add to: #{node_id}"
          action = default_action.merge(target_id: node_id)
          worker.add(action)
        end

        # favorite_topic_ids
        default_action = {
          action_type: 'favorite',
          target_type: 'Topic',
          user_id: u.id
        }
        puts "User:#{u.id} favorite topics"
        u[:favorite_topic_ids].each do |topic_id|
          puts "  Add to: #{topic_id}"
          action = default_action.merge(target_id: topic_id)
          worker.add(action)
        end
      end
    end
  end
end