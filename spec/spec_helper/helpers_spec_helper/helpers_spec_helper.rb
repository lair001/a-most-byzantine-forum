class Request

  attr_accessor :path_info

end

class Helper

  include ForumUsersHelper
  include ForumThreadsHelper
  include ForumPostsHelper
  include ApplicationHelper
  include RoutesHelper
  include TitlesHelper
  include TaglinesHelper

  # include PathsHelper::Application
  # include PathsHelper::ForumUsers
  # include PathsHelper::ForumThreads
  # include PathsHelper::ForumPosts
  # include PathsHelper::Sessions

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
    self.session = {}
  end

  def redirect(string)
    string
  end

  def view_current_user
    @current_user.dup.freeze
  end

end

# RSpec.configure do |config|
#     config.before(:each) { @helper = Helper.new }
# end

module HelperContext
  extend RSpec::SharedContext
  let(:helper) { Helper.new }
end

# mix path macros into rspec environment
include PathsHelper::Application
include PathsHelper::ForumUsers
include PathsHelper::ForumThreads
include PathsHelper::ForumPosts
include PathsHelper::Sessions
