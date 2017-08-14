require 'date'            # Include Date object
require 'time'            # Include Time object
require 'securerandom'    # Generate unique IDs
require 'rufus-scheduler' # Gem to create a thread scheduler
require 'highline'        # Gem to create better command line interface
require 'tty-prompt'      # Gem to create better console prompt component
require 'terminal-table'  # Gem to create tabled UI for the console
require 'os'              # Gem to detect the user's operating system
require 'mail'            # Gem to create e-mail messages
require 'colorize'        # Gem to change the color of the text


require_relative 'helpers'    # Class which provides our validation rules, calculation and convertion
require_relative 'question'   # Class which provides common questions and validate answers
require_relative 'goalsetter' # Class which runs our app and drives the menu
require_relative 'goal'       # Class which creates tasks
require_relative 'task'       # Class which contains the details of the tasks and creates a notification service
require_relative 'scheduler'  # Class which creates the scheduled popup messages and email messages
require_relative 'popup'      # Class which sends popup messages to the user
require_relative 'email'      # Class which sends email messages to the user

# People need a SMART Goal Setter because they have Goals.
# In every Goal, there are Tasks that need to be achieved/completed.
# People need Reminders/Encouragement for these Tasks.

# Some facts about the app:
# This is a Single User App
# It is compatible with MacOS, Linux
# Windows support will be added soon
# It guides users by asking the right questions in a very SMART way

module SmartGoals
  # Create a constant PROMPT instance
  PROMPT = TTY::Prompt.new

  # Cretea a constant CLI instance
  CLI = HighLine.new
  
  # Create the GOALSEETTER instance
  GOALSETTER = GoalSetter.new
  
  # Execute the program
  GOALSETTER.run_program
end
