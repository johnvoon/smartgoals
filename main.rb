require 'date'
require 'rufus-scheduler'
require 'highline'
require 'tty-prompt'
<<<<<<< HEAD
require 'os'
=======
require 'terminal-table'
>>>>>>> a99b3c95cdc754123ffbb1813577f7fefffb9831

require_relative 'goalsetter'
require_relative 'goal'
require_relative 'task'
require_relative 'notification_service'

# People need a SMART Goal Setter because they have Goals.
# In every Goal, there are Tasks that need to be achieved/completed.
# People need Reminders/Encouragement for these Tasks.

# Some facts about the app:
# This is a Single User App
# It guides users by asking the right questions in a very SMART way

module SmartGoals
  PROMPT = TTY::Prompt.new
  CLI = HighLine.new
  GoalSetter.new.run_program
end
# notificationService = NotificationService.new

# t1 = Thread.new {
#     notificationService.message
# }

# t2 = Thread.new {
#     while true do
#         print "You can do anything until you type exit : "
#         test_input = gets.chomp
#         if test_input == 'exit'
#             notificationService.shutdown   # Shutdown the Notification Service when you exit the app
#             break
#         else
#             puts test_input
#         end
#     end
# }
# t1.join
# t2.join

# system("echo 'Hello Smart Goals!' | terminal-notifier -sound default")

