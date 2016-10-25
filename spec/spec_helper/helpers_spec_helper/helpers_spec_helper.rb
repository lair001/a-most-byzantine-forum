class Request

  attr_accessor :path_info

end

class Helper

  include ForumUsersHelper
  include ForumThreadsHelper
  include ForumPostsHelper
  include ApplicationHelper

  ATTR_ARRAY = [
    :session,
    :user_posts,
    :threads,
    :users,
    :thread_posts,
    :slug,
    :params,
    :request,
    :thread
  ]

  ATTR_ARRAY.each { |attr| attr_accessor attr }

  def initialize
    self.request = Request.new
    self.params = {}
  end

  def redirect(string)
    string
  end

  def view_current_user
    @current_user.dup.freeze
  end

end