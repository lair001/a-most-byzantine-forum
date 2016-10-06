ForumUser.create(username: "lair001", email: "lair001@hotmail.com", password: "lair001", moderator: true, administrator: true, id: 1)
sleep 2
ForumUser.create(username: "lair002", email: "lair002@hotmail.com", password: "lair002", moderator: true, administrator: true, id: 2)
sleep 2
ForumUser.create(username: "lair003", email: "lair003@hotmail.com", password: "lair003", moderator: true, id: 3)
sleep 2
ForumUser.create(username: "lair004", email: "lair004@hotmail.com", password: "lair004", id: 4)
sleep 2
ForumUser.create(username: "lair005", email: "lair005@hotmail.com", password: "lair005", id: 5)
sleep 2

ForumThread.create(title: "first thread", id: 1)
sleep 2
ForumThread.create(title: "second thread", id: 2)
sleep 2
ForumThread.create(title: "third thread", id: 3)
sleep 2
ForumThread.create(title: "fourth thread", id: 4)
sleep 2
ForumThread.create(title: "fifth thread", id: 5)
sleep 2

ForumPost.create(content: "posting first in the first thread", forum_user_id: 1, forum_thread_id: 1)
sleep 2
ForumPost.create(content: "posting first in the second thread", forum_user_id: 2, forum_thread_id: 2)
sleep 2
ForumPost.create(content: "posting first in the third thread", forum_user_id: 3, forum_thread_id: 3)
sleep 2
ForumPost.create(content: "posting first in the fourth thread", forum_user_id: 4, forum_thread_id: 4)
sleep 2
ForumPost.create(content: "posting first in the fifth thread", forum_user_id: 5, forum_thread_id: 5)
sleep 2

ForumPost.create(content: "posting second in the first thread", forum_user_id: 2, forum_thread_id: 1)
sleep 2
ForumPost.create(content: "posting second in the second thread", forum_user_id: 3, forum_thread_id: 2)
sleep 2
ForumPost.create(content: "posting second in the third thread", forum_user_id: 4, forum_thread_id: 3)
sleep 2
ForumPost.create(content: "posting second in the fourth thread", forum_user_id: 5, forum_thread_id: 4)
sleep 2
ForumPost.create(content: "posting second in the fifth thread", forum_user_id: 1, forum_thread_id: 5)
sleep 2

ForumPost.create(content: "posting third in the first thread", forum_user_id: 3, forum_thread_id: 1)
sleep 2
ForumPost.create(content: "posting third in the second thread", forum_user_id: 4, forum_thread_id: 2)
sleep 2
ForumPost.create(content: "posting third in the third thread", forum_user_id: 5, forum_thread_id: 3)
sleep 2
ForumPost.create(content: "posting third in the fourth thread", forum_user_id: 1, forum_thread_id: 4)
sleep 2
ForumPost.create(content: "posting third in the fifth thread", forum_user_id: 2, forum_thread_id: 5)
sleep 2

ForumPost.create(content: "posting fourth in the first thread", forum_user_id: 4, forum_thread_id: 1)
sleep 2
ForumPost.create(content: "posting fourth in the second thread", forum_user_id: 5, forum_thread_id: 2)
sleep 2
ForumPost.create(content: "posting fourth in the third thread", forum_user_id: 1, forum_thread_id: 3)
sleep 2
ForumPost.create(content: "posting fourth in the fourth thread", forum_user_id: 2, forum_thread_id: 4)
sleep 2
ForumPost.create(content: "posting fourth in the fifth thread", forum_user_id: 3, forum_thread_id: 5)
sleep 2

ForumPost.create(content: "posting fifth in the first thread", forum_user_id: 5, forum_thread_id: 1)
sleep 2
ForumPost.create(content: "posting fifth in the second thread", forum_user_id: 1, forum_thread_id: 2)
sleep 2
ForumPost.create(content: "posting fifth in the third thread", forum_user_id: 2, forum_thread_id: 3)
sleep 2
ForumPost.create(content: "posting fifth in the fourth thread", forum_user_id: 3, forum_thread_id: 4)
sleep 2
ForumPost.create(content: "posting fifth in the fifth thread", forum_user_id: 4, forum_thread_id: 5)
sleep 2