# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
- [x] Use ActiveRecord for storing information in a database
- [x] Include more than one model class (list of model class names e.g. User, Post, Category)
      The models are ForumUsers, ForumPosts and ForumThreads
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Posts)
      A ForumPost belongs to a ForumUser and a ForumThread.
      ForumUsers have many ForumPosts.
      ForumThreads have many ForumPosts.
      ForumUsers have many ForumThreads.
      ForumThreads have many ForumUsers.
- [x] Include user accounts
- [x] Ensure that users can't modify content created by other users
      The only users who can modify content created by other users are moderators.  If you don't create any moderators, then
      noone can edit other user's posts.  Your forum will most likely descend into chaos as a result.  By design,
      administrators (who can modify the account information of other users) and moderators cannot be created through the app.
      They can only be created by manually manipulating the database through Tux, Sqlite3, or an editor for Sqlite3 databases.
      It is a potential security risk to allow such powerful permissions to be granted by HTTP requests.
- [x] Include user input validations
      There are a ton of validations for the models including stock ActiveRecord validations and custom validations.
      ForumUser validates:
      
        validates :username, presence: true
        validates :email, presence: true
        validates :password_digest, presence: true

        validate do
          presence_of_unique_slug
          absence_of_forbidden_characters_in :username
          absence_of_forbidden_characters_in :password
          only_spaces_as_whitespace_in :username
          absence_of_whitespace_in :email
          email_format
          absence_of_whitespace_in :password
        end
        
     ForumThread validates:
     
        validates :title, presence: true

        validate do 
          presence_of_unique_slug
          absence_of_forbidden_characters_in :title
          only_spaces_as_whitespace_in :title
        end
        
     ForumPost validates:
     
        validates :content, presence: true
        validates :forum_user_id, presence: true
        validates :forum_thread_id, presence: true

        validate do
          absence_of_forbidden_characters_in :content
        end

- [x] Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
