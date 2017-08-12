require 'date'
require 'time'
require 'rufus-scheduler'
require 'highline'
require 'tty-prompt'
require 'terminal-table'
require 'os'
require 'concurrent'

require_relative 'helpers'
require_relative 'goalsetter'
require_relative 'goal'
require_relative 'task'
require_relative 'scheduler'

# People need a SMART Goal Setter because they have Goals.
# In every Goal, there are Tasks that need to be achieved/completed.
# People need Reminders/Encouragement for these Tasks.

# Some facts about the app:
# This is a Single User App
# It guides users by asking the right questions in a very SMART way

module SmartGoals
  PROMPT = TTY::Prompt.new
  CLI = HighLine.new
  GOALSETTER = GoalSetter.new
  GOALSETTER.run_program
end
