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
    attr_accessor :recurring_schedulers
    attr_reader   :question     # question    : Question

    # How to describe it
    def initialize
      @tasks = []
      @recurring_schedulers = []
      @completed = false # Goal is set to "not completed" upon creation
      @question = Question.new
    end

    # Add new task to list of tasks
    def add_task(task)
      @tasks << task
    end

    # Display the current goal
    def display_goal
      puts "\nYOUR CURRENT GOAL IS: #{self.description}"
      if self.target_date
        puts "\nTARGET DATE TO REACH YOUR GOAL: #{self.target_date.strftime('%-d %B %Y')}"
      end
      if self.attainable
        puts "\nWHY I CAN ACHIEVE THIS GOAL: #{self.attainable}"
      end
      if self.relevant
        puts "\nWHY THIS GOAL MATTERS: #{self.relevant}"
      end
    end

    # Change color of the text in the table
    def generate_color(status)
      if status == :completed
        :green
      elsif status == :failed
        :red
      else
        :yellow
      end
    end

    # Display list of tasks for Terminal Table
    def display_tasks(status)

      # Create rows array
      rows = []
      table_title =
        case status
        when :todo then "Your Tasks To Be Done".colorize(generate_color(status))
        when :completed then "Your Completed Tasks".colorize(generate_color(status))
        when :failed then "Your Failed Tasks".colorize(generate_color(status))
        end

      # Check if tasks were created
      if !@tasks.empty?
        @tasks
        .select {|task| task.status == status }
        .each_with_index do |task, index|
        # Append tasks to rows array
          rows << [
            (index + 1).to_s.colorize(generate_color(status)),
            task.description.colorize(generate_color(status)),
            task.frequency.to_s.gsub('_', ' ').capitalize.colorize(generate_color(status)),
            task.target_date ? task.target_date.strftime("%d/%m/%Y %I:%M:%S %p").colorize(generate_color(status)) : ""
          ] if task.status == status
        end
      else
        # No tasks were created. Just display "No tasks added yet"
        rows << ["", "No tasks added yet"]
      end

      # Create terminal table for tasks
      tasks = Terminal::Table.new(
        title: table_title,
        headings: ['No.', 'Description', 'Recurring', 'Target Date/Time'],
        rows: rows
      )

      # Display terminal table
      puts ""
      puts tasks
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

    # Create new tasks
    def create_tasks
      system "clear"
      if CLI.agree("\nWould you like to set tasks now? (y/n)")
        loop do
          display_goal
          display_tasks(:todo)
          task = Task.new
          task.description = @question.ask_for_description("\nDescribe your task:")
          task.frequency = get_frequency
          task.creation_date = Time.now.getlocal

          case task.frequency
            when :once
              task.target_date = @question.ask_for_target_date("\nWhen do you aim to complete this task by (dd-mm-yyyy)? \nMake sure your timeframe is REALISTIC.")

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
          display_goal
          display_tasks(:todo)
          break unless CLI.agree("\nWould you like to set a new task? (yes/no)")
        end
      end
    end

    # Schedule a recurring task
    def schedule_recurring_task_creation(task)
      recurring_scheduler = Scheduler.new
      @recurring_schedulers << recurring_scheduler

      recurring_scheduler.schedule.every "#{Helpers.convert_frequency_to_seconds(task.frequency).to_s}s" do
        new_task = Task.new
        new_task.description = task.description
        new_task.frequency = task.frequency
        new_task.creation_date = Time.now.getlocal
        new_task.target_date = Helpers.calculate_task_target_date(
          new_task.creation_date,
          new_task.frequency
        )
        new_task.recurring_scheduler_id = recurring_scheduler.id

        new_task.create_reminder_notification
        new_task.create_failed_notification

        add_task(new_task)
      end
    end

    # Displays the Task Management Menu
    def display_task_management_menu
      loop do
        system "clear"
        self.view_tasks
        puts ""
        choice = PROMPT.select("What would you like to do for your goal?") do |menu|
          menu.choice 'Create New Tasks', '1'
          menu.choice 'Delete Task', '2'
          menu.choice 'Mark Tasks Complete', '3'
          menu.choice 'Back', '4'
        end

        case choice
        when '1'
          create_tasks
        when '2'
          delete_task
        when '3'
          mark_task_complete
        when '4'
          break
        end
      end
    end

    # Prompt for choice on Task Management Menu and Selects that Choice
    def get_task_choice(operation)
      system "clear"
      display_tasks(:completed)
      display_tasks(:failed)
      if @tasks.empty?
        # Check if operation is create
        if operation == "create"
          create_tasks
        else
          # Only verify this if it's not a create operation
          choice = CLI.agree("You haven't set any tasks yet. Set a task now? (y/n)")
          if choice
            create_tasks
          end
        end
      else
        todo_tasks = {}
        @tasks
          .select {|task| task.status == :todo}
          .each_with_index do |task, index|
            todo_tasks["#{index + 1}. #{task.description}"] = task
          end
        todo_tasks["#{todo_tasks.length + 1}. Back"] = :back

        task = PROMPT.select("\nSelect an ONGOING task to #{operation}:", todo_tasks)
      end
      # Return task choice
      task
    end

    # View selected task
    def view_tasks
      display_goal

      display_tasks(:completed)
      display_tasks(:failed)
      display_tasks(:todo)
    end

    # Edit selected task
    def edit_task
      system "clear"
      task = get_task_choice("edit")

      # If task was set
      if task && task != :back
        loop do
          system "clear"
          attributes = {
            "Description: #{task.description}": :description,
            "Frequency: #{task.frequency}": :frequency,
            "Back": :back
          }
          attribute = PROMPT.select("Select which task attribute to edit", attributes)
          if attribute == :description

            # Change the description
            task.description = @question.ask_for_description("Enter new description")
            
            # Cancel notifications
            task.cancel_reminder_notification
            task.cancel_failed_notification

            # Re-create the notification
            task.create_reminder_notification
            task.create_failed_notification

            # Shutdown previous schedule
            recurring_scheduler_first =
              @recurring_schedulers
                .select {|scheduler| scheduler.id == task.recurring_scheduler_id }
                .first
            recurring_scheduler_first.schedule.shutdown if recurring_scheduler_first

            # Reschedule the recurring task creation
            schedule_recurring_task_creation(task)

          elsif attribute == :frequency

            # Change the frequency
            frequency = get_frequency
            task.frequency = frequency
            
            # Cancel notifications
            task.cancel_reminder_notification
            task.cancel_failed_notification

            # Shutdown previous schedule
            recurring_scheduler_first =
              @recurring_schedulers
                .select {|scheduler| scheduler.id == task.recurring_scheduler_id }
                .first
            recurring_scheduler_first.schedule.shutdown if recurring_scheduler_first

            # Reschedule the recurring task creation
            schedule_recurring_task_creation(task)
          elsif attribute == :back
            break
          end
          break unless CLI.agree("\nEdit another attribute? (y/n)")
        end
      end
    end

    # Delete selected task
    def delete_task
      system "clear"
      loop do
        task = get_task_choice("delete")
        # If task was set
        if task && task != :back
          # Cancel notifications
          task.cancel_reminder_notification
          task.cancel_failed_notification

          # Delete task from array of tasks
          @tasks.delete(task)

          # If recurring scheduler set, shut it down
          recurring_scheduler_first =
            @recurring_schedulers
              .select {|scheduler| scheduler.id == task.recurring_scheduler_id }
              .first
          recurring_scheduler_first.schedule.shutdown if recurring_scheduler_first
          break unless CLI.agree("\nDelete another task? (y/n)")
        else
          # Just go back to menu
          break
        end
      end
    end

    # Mark task as complete
    def mark_task_complete
      system "clear"
      # If task was set

      loop do
        task = get_task_choice("mark complete")
        if task && task != :back
          task.status = :completed

          system "clear"
          display_tasks(:completed)
          display_tasks(:failed)

          # Cancel notifications
          task.cancel_reminder_notification
          task.cancel_failed_notification

          puts "Congratulations on completing this task!"
          break unless CLI.agree("\nMark another task complete? (y/n)")
        else
          break
        end
      end
    end
  end
end