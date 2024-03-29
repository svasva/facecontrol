ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  section 'Characters activity' do
    table do
      tr do
        th 'Time', :width => '150px'
        th 'Character', :width => '150px'
        th 'Subject'
        th 'GameAction'
      end
      CharacterAction.last_ten.collect do |ca|
        tr do
          td "#{time_ago_in_words ca.created_at} ago"
          td link_to ca.character.name, admin_character_path(ca.character)
          td "#{ca.game_action.subject.name if ca.game_action.subject}"
          td raw "#{ca.game_action.name}"
        end
      end
    end
  end

  section 'Top 10 characters' do
    table do
      tr do
        th 'Character'
        th 'Glory'
      end
      Character.order('glory DESC').limit(10).collect do |char|
        tr do
          td link_to char.name, admin_character_path(char)
          td char.glory
        end
      end
    end

  end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
