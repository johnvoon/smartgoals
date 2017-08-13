require 'pry'
# Purpose: To Create Tasks
module SmartGoals
  class Goal
    # What it has
    attr_accessor :description  # description : String
    attr_accessor :target_date  # target_date : Time
    attr_accessor :completed    # completed   : Boolean
    attr_accessor :tasks        # tasks       : Array of Task
    attr_accessor :attainable   # attainable  : String
    attr_accessor :relevant     # relevant    : String

    # How to describe it
    def initialize
      @tasks = []
      @completed = false # Goal is set to "not completed" upon creation
    end

    # Add new task to list of tasks
    def add_task(task)
      @tasks << task
    end

    # Display the current goal
    def display_goal(goal)
      puts "\nYOUR CURRENT GOAL IS: #{goal.description}"
      if goal.target_date
        puts "TARGET DATE TO REACH YOUR GOAL: #{goal.target_date.strftime('%-d %B %Y')}"
      end
    end

    # Display list of tasks for Prompt
    def display_task_options(selected_operation) # selected_operation: String
      # Create new hash for tasks
      tasks = {}

      # Display list of goals
      @tasks.each_with_index do |task, index|
        goals["#{index + 1}. #{task.description}"] = "#{index + 1}"
      end

      # Prompt user to select a task
      selected_task = SmartGoals::PROMPT.select(
        "Select a task to #{selected_operation}?",
        tasks
      )

      selected_task
    end

    # Display list of tasks for Terminal Table
    def display_tasks
      # Create rows array
      rows = []

      # Check if tasks were created
      if !@tasks.empty?
        @tasks.each_with_index do |task, index|
          # Append tasks to rows array
          rows << [
            (index + 1).to_s,
            task.description,
            task.frequency.to_s.gsub('_', ' ').capitalize,
            task.target_date ? task.target_date.strftime("%d/%m/%Y") : ""
          ]
        end
      else
        # No tasks were created. Just display "No tasks added yet"
        rows << ["", "No tasks added yet"]
      end

      # Create terminal table for tasks
      table = Terminal::Table.new(
        title: "Your Tasks",
        headings: ['No.', 'Description', 'Recurring', 'Target Date'],
        rows: rows
      )

      # Display terminal table
      puts ""
      puts table
    end

    # Display prompt for frequency
    def get_frequency
      PROMPT.select("\nHow often would you like to do this task?") do |menu|
        menu.choice 'Just once', :once
        menu.choice 'Every Minute', :every_minute
        menu.choice 'Hourly', :hourly
        menu.choice 'Daily', :daily
        menu.choice 'Weekly', :weekly
        menu.choice 'Monthly', :monthly
        menu.choice 'Yearly', :yearly
      end
    end


    def create_tasks
      system "clear"
      puts <<~MESSAGE
        At the moment your goal is still too big and daunting to be achieved.
        So we will need to break your goal down into a series of tasks.
        Make sure these tasks also meet the SMART criteria.
      MESSAGE
      if CLI.agree("\nWould you like to set these tasks now? (y/n)")
        loop do
          display_goal(self)
          display_tasks
          task = Task.new
          task.description = CLI.ask("\nDescribe your task:")
          task.frequency = get_frequency
          task.creation_date = Time.now.getlocal

          case task.frequency
            when :once
              target_date = CLI.ask("\nWhen do you aim to complete this task by (dd-mm-yyyy)? Make sure your timeframe is realistic.") do |q|
                q.validate = Helpers.valid_date?
                q.responses[:not_valid] = "Please enter a date in the future."
                q.responses[:invalid_type] = "Please enter a valid date in the format 'dd-mm-yyyy'."
              end
              task.target_date = Time.strptime(target_date, '%d-%m-Y')
            else
              task.target_date = Helpers.calculate_task_target_date(
                task.creation_date,
                task.frequency
              )
              schedule_recurring_task_creation(task)
          end

          add_task(task)
          task.goal = self
          task.create_reminder_notification
          task.create_failed_notification
          
          system "clear"
          display_goal(self)
          display_tasks
          break unless CLI.agree("\nWould you like to set a new task? (yes/no)")
        end
      end
    end

    def schedule_recurring_task_creation(task)
      scheduler = Rufus::Scheduler.new
      scheduler.every "#{Helpers.convert_frequency_to_seconds(task.frequency).to_s}s" do
        new_task = Task.new
        new_task.description = task.description
        new_task.frequency = task.frequency
        new_task.creation_date = Time.now.getlocal
        new_task.target_date = Helpers.calculate_task_target_date(
          new_task.creation_date,
          new_task.frequency
        )

        new_task.create_reminder_notification
        new_task.create_failed_notification

        add_task(new_task)
      end
    end

    def display_task_management_menu
      loop do
        system "clear"
        choice = PROMPT.select("What would you like to do for your goal?") do |menu|
          menu.choice 'Create New Tasks', '1'
          menu.choice 'Edit Task', '2'
          menu.choice 'Delete Task', '3'
          menu.choice 'Mark Tasks Complete', '4'
          menu.choice 'Back', '5'
        end

        case choice
        when '1'
          create_tasks
        when '2'
          edit_task
        when '3'
          delete_task
        when '4'
          mark_task_complete
        when '5'
          break
        end
      end
    end

    def get_task_choice(operation)
      system "clear"
      if @tasks.empty?
        choice = CLI.agree("You haven't set any tasks yet. Set a task now? (y/n)")
        if choice
          create_tasks
        end
      else
      tasks = {}
      @tasks.each_with_index { |task, index| tasks["#{index + 1}. #{task.description}"] = task }
      task = PROMPT.select("Select a task to #{operation}:", tasks)
      end
      task
    end

    def view_tasks
      puts "View Tasks"
      get_task_choice("view")
    end

    def edit_task
      system "clear"
      task = get_task_choice("edit")

      # If task was set
      if !task.nil?
        loop do
          system "clear"
          attributes = {
            "Description: #{task.description}": :description,
            "Frequency: #{task.frequency}": :frequency,
            "Back": :back
          }
          attribute = PROMPT.select("Select which task attribute to edit", attributes)
          if attribute == :description
            description = CLI.ask("Enter new description") do |q|
                # Check if the description is empty
                q.validate = Helpers.not_empty?
        
                # Description is empty
                q.responses[:not_valid] = "\nInvalid description. Please enter a valid description."
            end
            task.description = description
          elsif attribute == :frequency
            frequency = get_frequency
            task.frequency = frequency
          elsif attribute == :back
            break
          end
          break unless CLI.agree("Edit another attribute? (y/n)")
        end
      else
        # Just go back to menu
      end
    end

    def delete_task
      system "clear"
      loop do
        task = get_task_choice("delete")
        # If task was set
        if !task.nil?
          @tasks.delete(task)
          break unless CLI.agree("Delete another task? (y/n)")
        else
          # Just go back to menu
          break
        end
      end
    end

    def mark_task_complete
      system "clear"
      loop do
        task = get_task_choice("mark complete")
        # If task was set
        if !task.nil?
          task.status = :completed
          puts "Congratulations on completing this task!"
          break unless CLI.agree("Mark another task complete? (y/n)")
        else
          # Just go back to menu
          break
        end
      end
    end

  end
end