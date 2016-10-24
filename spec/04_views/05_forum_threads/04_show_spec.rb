require 'sinatra_helper'
require 'views_spec_helper'
require 'helpers_spec_helper'

describe 'forum_users/show' do

    before do
        @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
        @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
        @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
        @user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
        @user6 = ForumUser.create(username: "zack", email: "zack@zack.com", password: "zack", id: 6)
        @user7 = ForumUser.create(username: "ed", email: "ed@ed.com", password: "ed", id: 7, banned: true)

        @thread1 = ForumThread.create(title: "the worst first", id: 1)
        @thread4 = ForumThread.create(title: "Hello and Goodbye, Phil", id: 4)
        @thread5 = ForumThread.create(title: "The Great Schism", id: 5)
        @thread6 = ForumThread.create(title: "Iconoclasm in the 10th Century", id: 6)

        @post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
        @post2 = ForumPost.create(content: "Hal, do you want to be the first to be banned?", forum_user_id: 1, forum_thread_id: 1)
        @post3 = ForumPost.create(content: "You insult my honor, my lady.", forum_user_id: 2, forum_thread_id: 1)
        @post4 = ForumPost.create(content: "Let me do it!", forum_user_id: 3, forum_thread_id: 1)
        @post5 = ForumPost.create(content: "Wait, my hand slipped. I swear!", forum_user_id: 2, forum_thread_id: 1)
        @post6 = ForumPost.create(content: "I always wanted to change someone's username to Cthulhu.", forum_user_id: 4, forum_thread_id: 1)
        @post7 = ForumPost.create(content: "Fiddlesticks", forum_user_id: 2, forum_thread_id: 1)
        @post1.update(content: "I'm sorry, please don't ban me.", forum_user_id: 2, forum_thread_id: 1)
        @post3.update(content: "Maybe I was too confrontational.", forum_user_id: 2, forum_thread_id: 1)
        @post9 = ForumPost.create(content: "Hardly knew ya, Phil.", forum_user_id: 6, forum_thread_id: 4)
        @post10 = ForumPost.create(content: "I am the first to create an on topic thread.", forum_user_id: 4, forum_thread_id: 5)
        @post11 = ForumPost.create(content: "And so the Pope and the Greek Patriarch had a squabble over . . .", forum_user_id: 4, forum_thread_id: 6)
        @post12 = ForumPost.create(content: "I am on a roll.", forum_user_id: 4, forum_thread_id: 6)
        @post13 = ForumPost.create(content: "I don't remember creating a forum about Byzantine History.", forum_user_id: 1, forum_thread_id: 5)
        @post14 = ForumPost.create(content: "That is Roman History to you.", forum_user_id: 4, forum_thread_id: 5)
        @post15 = ForumPost.create(content: "This is madness.", forum_user_id: 6, forum_thread_id: 5)

        @thread1_posts_array = @thread1.forum_posts.sort { |a, b| a.created_at <=> b.created_at }
        @thread5_posts_array = @thread5.forum_posts.sort { |a, b| a.created_at <=> b.created_at }

        @helper1 = Helper.new
    end

    it "renders a thread detail view with a listing of the thread's posts (posts are ordered in the order that they were created)" do
        use_view_to_login_as(@user6)
        visit "/forum_threads/#{@thread1.slug}"

        expect(page.body).to include(@thread1.title)

        #testing for order of posts using css selectors
        post_selector = 'div.forum-divider-top div.row a'
        @thread1_posts_array.each do |post|
        	expect(page.body).to include(@helper1.format_time(post.updated_at))
        	expect(page.body).to include(@helper1.format_time(post.created_at))
        	expect(page.body).to include(post.content)
        	expect(page.first(post_selector + "[href='/forum_users/#{post.forum_user.slug}']").text).to include(post.forum_user.username)
        	post_selector = 'div.forum-divider-top+' + post_selector
        end
        page.assert_selector('div.row a', count: @thread1_posts_array.length)
    end

    it "renders a button to edit each post if logged in as a moderator" do
        use_view_to_login_as(@user3)
        visit "/forum_threads/#{@thread1.slug}"
        @thread1_posts_array.each do |post|
            expect(page).to have_link('Edit', href: "/forum_posts/#{post.id}/edit")
        end
    end

    it "renders a button to edit each of the user's posts in the thread if logged in as an ordinary user" do
        use_view_to_login_as(@user2)
        visit "/forum_threads/#{@thread1.slug}"

        @thread1_posts_array.each do |post|
            if post.forum_user == @user2
                expect(page).to have_link('Edit', href: "/forum_posts/#{post.id}/edit")
            else
                expect(page).to have_no_link('Edit', href: "/forum_posts/#{post.id}/edit")
            end
        end
    end

    it "renders a button to edit each of the user's posts in the thread if logged in as an administrator without moderator powers" do
        use_view_to_login_as(@user4)
        visit "/forum_threads/#{@thread1.slug}"

        @thread1_posts_array.each do |post|
            if post.forum_user == @user4
                expect(page).to have_link('Edit', href: "/forum_posts/#{post.id}/edit")
            else
                expect(page).to have_no_link('Edit', href: "/forum_posts/#{post.id}/edit")
            end
        end
    end

    it "renders a button to delete each post in a thread except for the first if logged in as a moderator" do 
        use_view_to_login_as(@user3)
        visit "/forum_threads/#{@thread1.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        @thread1_posts_array.each do |post|
            if post != @thread1_posts_array.first
                expect(page).to have_css("input#delete_post_#{post.id}")
            else
                expect(page).to have_no_css("input#delete_post_#{post.id}")
            end
        end
    end

    it "renders a button to delete the first post in a thread if the thread has only one post and logged in as a moderator" do 
        use_view_to_login_as(@user3)
        visit "/forum_threads/#{@thread4.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        expect(page).to have_css("input#delete_post_#{@post9.id}")
    end

    it "does not render a button to delete the posts of other users but does render a button to delete each of the current user's post in a thread except for the thread's first post if logged in as an ordinary user" do 
        use_view_to_login_as(@user2)
        visit "/forum_threads/#{@thread1.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        @thread1_posts_array.each do |post|
            if post.forum_user == @user2 && post != @thread1_posts_array.first
                expect(page).to have_css("input#delete_post_#{post.id}")
            else
                expect(page).to have_no_css("input#delete_post_#{post.id}")
            end
        end
    end

    it "renders a button to delete the first post of a thread if the post belongs the user, the thread has only one post, and logged in as an ordinary user " do 
        use_view_to_login_as(@user6)
        visit "/forum_threads/#{@thread4.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        expect(page).to have_css("input#delete_post_#{@post9.id}")
    end

    it "does not render a button to delete the posts of other users but does render a button to delete each of the current user's post in a thread except for the thread's first post if logged in as an administrator without moderator powers" do 
        use_view_to_login_as(@user4)
        visit "/forum_threads/#{@thread5.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        @thread5_posts_array.each do |post|
            if post.forum_user == @user4 && post != @thread5_posts_array.first
                expect(page).to have_css("input#delete_post_#{post.id}")
            else
                expect(page).to have_no_css("input#delete_post_#{post.id}")
            end
        end
    end

    it "renders a button to delete the first post of a thread if the post belongs the user, the thread has only one post, and logged in as an administrator without moderator powers" do 
        use_view_to_login_as(@user4)
        visit "/forum_threads/#{@thread6.slug}"
        expect(page).to have_css('form[method="post"][action="/forum_posts"]')
        expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
        expect(page).to have_css("input#delete_post_#{@post12.id}")
    end

    it "renders a button to quote any post that is not the user's" do
        use_view_to_login_as(@user2)
        visit "/forum_threads/#{@thread1.slug}"
        @thread1_posts_array.each do |post|
            if post.forum_user != @user2
                expect(page.first("div##{post.id} button").text).to include("Quote")
            else
                expect(page).to have_no_css("div##{post.id} button")
            end
        end
    end

end