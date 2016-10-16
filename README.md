# A Most Byzantine Forum

`A Most Byzantine Forum` is a Byzantine themed forum platform built using `Sinatra`.

## Installation

This web app can be installed by cloning the GitHub [repository](https://github.com/lair001/a-most-byzantine-forum) to your system.  You may also host it live on your own server or a hosting service such as [Heroku](https://www.heroku.com/) or [Amazon Web Services](https://aws.amazon.com/).

## Usage

If you have cloned the GitHub repository to your system, you can start the app by navigating to the directory containing the repository and running `shotgun`.  You can then view the web app's homepage by navigation to http://127.0.0.1:9393/ in your browser of choice.

### Signing Up and Logging In

You may sign up or login by following links at the bottom of the homepage.  Upon logging in or creating an account, you will be taken to a listing the forum's threads.

### Navbar

The right side of the navbar includes a `Navigation` dropdown menu that contains links to the top and bottom of a page.  It also includes buttons for logging out, navigating to a list of threads, navigating to the current user's profile page, and navigating to a list of users.

The right side of the navbar includes a field to perform a Google Search.  If you are viewing the thread listing, it will have a `Create` button that takes you to a form to create a new thread.  If you are viewing the show page for a thread, it will have a `Create`button to create a new post for the thread.

### Thread Listing

Near the top of the thread listing page is a field to seach for a thread by title.  The listing itself includes the time a thread was last updated, the time it was created, and the thread's title.  Click on a thread's title will take you to the show page for that thread.  If you are a moderator, there are buttons to edit thread titles or delete entire threads.

### Thread Show Page

This page lists all posts in a thread.  This listing includes the username and title of the user who created the post, the times that the post was created and last updated, and the post's content.  Clicking on a username will take you to a profile page for that user.  If a post does not belong to the current user, there is a button to quote it.  If a post belongs to the current user, there are buttons to edit and delete it.  A moderator may delete the posts of any user.

### User Listing

Near the top of the user listing page is a field to seach for a user by title.  The listing itself includes a user's username, title, email address, last time the user was active, when the user joined.  Clicking on a username will take you to a profile page for the user.

### User Profile

The top of a user's profile includes username, title, last time the user was active, when the user joined, and email address.  If you are a moderator, there will be a button to ban or unban the user.  If you are viewing your own profile or if you are an administrator, there will be a button to edit the user's account information.

The bottom of the profile page includes a listing of the user's posts.  This listing includes when a post was last updated, when it was created, and the post's content.

### Creating Administrators and Moderators

For security reasons, it is only possible to set adminstrator and moderator permissions through `Tux` or a database editor.  To do it with `Tux`, navigate to the directory where the respository is cloned and run `tux`.  This takes you to Tux's command line.  

To set moderator permissions, run `ForumUser.find_by(username: "[username]").update(moderator: true)`.  To remove moderator permissions, run `ForumUser.find_by(username: "[username]").update(moderator: false)`.

To set administrator permissions, run `ForumUser.find_by(username: "[username]").update(administrator: true)`.  To remove moderator permissions, run `ForumUser.find_by(username: "[username]").update(administrator: false)`.

For example, `ForumUser.find_by(username: "The One").update(moderator: true)`will grant moderator permissions to the user whose username is `The One`.

You may exit the `Tux` command line by running `exit`.

### Easter Eggs

If you click the navbar brand, you will be taken to a tribute page for the last Byzantine Emperor, Constantine IX Palaiologos.  Clicking on the navbar brand again will take you to the homepage.

## Contributing

If you want to contribute, feel free to fork the `a-most-byzantine-forum`repository and submit a pull request.  You may also email Samuel Lair at lair002@gmail.com.

## License

This gem is open source under the [MIT license](https://github.com/lair001/a-most-byzantine-forum/blob/master/LICENSE.).