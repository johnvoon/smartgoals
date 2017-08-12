require 'date'
require 'rufus-scheduler'
require 'highline'
require 'tty-prompt'
require 'os'
require 'terminal-table'

require_relative 'goalsetter'
require_relative 'goal'
require_relative 'task'
require_relative 'notification_service'

# People need a SMART Goal Setter because they have Goals.
# In every Goal, there are Tasks that need to be achieved/completed.
# People need Reminders/Encouragement for these Tasks.

# Some facts about the app:
# This is a Single User App
# It is compatible with MacOS, Linux
# Windows support will be added soon
# It guides users by asking the right questions in a very SMART way

module SmartGoals
  PROMPT = TTY::Prompt.new
  CLI = HighLine.new
  GoalSetter.new.run_program
end
