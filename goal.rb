require 'pry'
# Purpose: To Create Tasks
module SmartGoals
  class Goal
    # What it has
    # description : String
    # completed : Boolean
    # sub_goals : Array of SubGoal
    attr_accessor :description
    attr_accessor :target_date
    attr_accessor :completed
    attr_accessor :sub_goals

    # How to describe it
    def initialize
      @tasks = []
      @completed = false # Goal is set to "not completed" upon creation
    end

    def display_goal(goal)
      puts "Your Goal: #{goal.description}"
    end

    def display_tasks
      rows = []

      if !@tasks.empty?
        @tasks.each_with_index do |task, index|
          rows << [
            index.to_s,
            task.description,
            task.frequency.to_s.capitalize,
            task.target_date ? task.target_date.strftime("%d/%m/%Y") : ""
          ]
        end
      else
        rows << ["", "No tasks added yet"]
      end

      table = Terminal::Table.new(
        title: "Your Tasks",
        headings: ['No.', 'Description', 'Recurring', 'Target Date'],
        rows: rows
      )

      puts ""
      puts table
    end

    def set_tasks
      system "clear"
      display_goal(self)
      puts "\nIt's time to set specific tasks so you can achieve your goal."
      email = ''
      loop do
        system "clear"
        display_goal(self)
        display_tasks

        if CLI.agree("\nSet a new task? (yes/no)")
          description = CLI.ask("\nDescribe your task:")

          if CLI.agree("\nIs this a task to be done regularly (yes/no)?")
            email = CLI.ask("\nEnter your email where for receiving reminders?") if email.empty?
            frequency = PROMPT.select("\nHow often would you like to do this task?") do |menu|
              menu.choice 'Daily', :daily
              menu.choice 'Weekly', :weekly
              menu.choice 'Monthly', :monthly
              menu.choice 'Yearly', :yearly
            end
          else
            system "clear"
            puts ""
            target_date = CLI.ask("\nWhen do you aim to complete this task by (dd-mm-yyyy)? Make sure your timeframe is realistic.")
          end

          @tasks << Task.new(
            description: description,
            frequency: frequency,
            target_date: target_date ? Date.strptime(target_date, '%d-%m-%Y') : nil
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