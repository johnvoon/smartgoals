require 'pry'
# Purpose: To Create Tasks
module SmartGoals
  class Goal
    # What it has
    # description : String
    # completed : Boolean
    # sub_goals : Array of SubGoal
    attr_accessor :description, :target_date, :completed, :sub_goals

    # How to describe it
    def initialize
      @tasks = []
      @completed = false # Goal is set to "not completed" upon creation
    end

    def set_tasks
      puts <<~MESSAGE
        It's time to set specific tasks so you can achieve your goal."

      MESSAGE
      email = ''
      loop do
        system "clear"
        if CLI.agree('Set a new task? (yes/no)')
          system "clear"
          description = CLI.ask('Describe your task:')

          if CLI.agree('Is this a task to be done regularly (yes/no)?')
            system "clear"
            email = CLI.ask('Enter your email where for receiving reminders?') if email.empty?
            system "clear"
            frequency = PROMPT.select("How often would you like to do this task?") do |menu|
              menu.choice 'Daily', :daily
              menu.choice 'Weekly', :weekly
              menu.choice 'Monthly', :monthly
              menu.choice 'Yearly', :yearly
            end
            # What if ongoing? 
            target_date = CLI.ask("When would you like to do this task until (dd-mm-yyyy)?")
          else
            system "clear"
            target_date = CLI.ask("When do you aim to complete this task by (dd-mm-yyyy)? Make sure your timeframe is realistic.")
          end

          @tasks << Task.new(
            description: description,
            frequency: frequency,
            target_date: Date.strptime(target_date, '%d-%m-%Y')
          )
        else
          break
        end
      end
    end

    # What can it do
    # TODO
    # add_task(task_id)
    # remove_task(task_id)
    # task_complete(task_id)
  end
end