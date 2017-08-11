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
    attr_accessor :tasks

    # How to describe it
    def initialize
      @tasks = []
      @completed = false # Goal is set to "not completed" upon creation
    end

    def display_goal(goal)
      puts "YOUR CURRENT GOAL IS: #{goal.description}"
    end

    def display_task_options(selected_operation) 
      # selected_operation: String
      tasks = {}
      @tasks.each_with_index { |task, index| goals["#{index + 1}. #{task.description}"] = "#{index + 1}"}
      selected_task = SmartGoals::PROMPT.select(
        "Select a task to #{selected_operation}?", 
        tasks
      )

      selected_task
    end

    def display_tasks_table
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
      puts <<~MESSAGE
        
        Hey welcome to the goal refinement centre! 
        
        As you go through this process you'll see your vague unspecific goal transform into something specific and actionable. You'll know exactly what your goal is and the specific tasks you need to complete to get there. You can imagine your goal now as piece of raw steel but by the time you go through this process it will be forged into a sword.
      
      MESSAGE

      email = ''
      loop do
        system "clear"
        display_goal(self)
        display_tasks_table

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

    def view_tasks
      puts "View Tasks"
    end

    def edit_tasks
      puts "Edit tasks"
      display_task_options("edit")
    end

    def delete_tasks
      puts "Delete tasks"
      display_task_options("delete")
    end

    # What can it do
    # TODO
    # add_task(task_id)
    # remove_task(task_id)
    # task_complete(task_id)
  end
end