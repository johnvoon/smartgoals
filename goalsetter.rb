# Purpose: To Create Goals
module SmartGoals
  class GoalSetter
    # What it has
    attr_accessor :name         # name : String
    attr_accessor :email        # email : String
    attr_accessor :friend_name  # friend_name : String
    attr_accessor :friend_email # friend_email :  String
    attr_accessor :goals        # goals : Array of Goal

    # How to describe it
    def initialize
      @goals = []
    end

    # What can it do
    # Start the app and display the menu
    def run_program
      # Display welcome screen
      welcome_screen

      # Display user menu choices
      get_goal_management_choice
    end

    # Display the welcome screen
    def welcome_screen
      system "clear"
      puts "Welcome to SMART Goals!"

      # Ask for the user's name
      @name = CLI.ask("\nWhat's your name?") do |n|
        # Check if the user's name is empty
        n.validate = Helpers.not_empty?

        # Name is empty
        n.responses[:not_valid] = "\nInvalid name. Please enter a valid name."
      end

      # Ask for the user's email
      @email = CLI.ask("\nWhat is your email? This is where we will be sending you notifications.") do |q|
        # Check if the user's email is valid
        q.validate = Helpers.valid_email?
        
        # Email is not in the right format
        q.responses[:not_valid] = "\nInvalid email entered. Please enter a valid email."
      end
    end

    # Display the menu choices
    def get_goal_management_choice
      loop do
        system "clear"

        # Make the user feel welcome
        puts "\nHi #{@name}! We will be guiding you through the process of setting SMART goals."
        
        # Ask the user for a menu choice
        choice = PROMPT.select("\nIf you are new user, select 'Create a SMART Goal'.") do |menu|
          menu.choice 'Create a SMART Goal', '1'
          menu.choice 'View a SMART Goal', '2'
          menu.choice 'Edit a SMART Goal', '3'
          menu.choice 'Delete a SMART Goal', '4'
          menu.choice 'Exit', '5'
        end

        case choice
          when '1'  # Create a SMART Goal
            create_goal
          when '2'  # View a SMART Goal
            view_goals
          when '3'  # Edit a SMART Goal
            edit_goal
          when '4'  # Delete a SMART Goal
            delete_goal
          when '5'  # Exit
            break
        end
      end
    end

    # Create a new goal
    def create_goal
      system "clear"
      goal = Goal.new
      
      # Ask the user for his Goal but not to worry about it too much at this point
      goal.description = CLI.ask("Please tell us your goal. Don't worry about it too much at this point.\nWe are just trying to get a base direction and will refine it later.\n\nDescribe your Goal:\n")
      
      # The goal description has been set. Thank the user. Tell him more about the app.
      puts <<~MESSAGE
        
        Thanks for telling us your goal! 
        
        Welcome to the Goal Refinement Centre. As you go through this process,
        you will see your vague unspecific goal transform into something specific
        and actionable. You will know exactly what your goal is and the specific
        tasks you need to complete to get there. You can imagine your goal now as
        piece of raw steel but by the time you go through this process it will be
        forged into a sword.
      
        Let's start out by setting an target date for achieving your goal. If you
        don't set a target date, your goal will just remain a fantasy. Setting a
        target date for your goal is important step in the SMART goal process.
      MESSAGE
      
      # Ask the user for a target date
      target_date = CLI.ask("\nPlease enter a target date (format: dd-mm-yyyy)") do |q|
        # Validate date
        q.validate = Helpers.valid_date?

        # Date should be a future date
        q.responses[:not_valid] = "Please enter a date in the future."

        # Date should be in d-m-Y format
        q.responses[:invalid_type] = "Please enter a valid date."
      end

      # Get the target date in d-m-Y format
      goal.target_date = Date.strptime(target_date, "%d-%m-%Y")

      # Display the SMART words
      list_smart_words

      # Display: Ask the user for the goal to be more specific
      make_goal_specific(goal)

      # Display: Ask the user if his goal is attainable
      make_goal_attainable(goal)

      # Display: Ask the user if his goal is relevant
      make_goal_relevant(goal)

      # Display: Ask the user for his friend's email
      set_friend_email

      # Display: Create the tasks
      goal.create_tasks
      @goals << goal

      # Display: Complete setting the goal
      finish_setting_goal
    end

    # Display list of SMART words
    def list_smart_words
      system "clear"
      puts <<~MESSAGE
        
        Now that we've set a target date, let's make your goals SMART:

        - Specific
        - Measurable
        - Attainable
        - Relevant
        - Timely

        You've already made your goal timely in the previous step. However you'll
        need to make your goal specific, measurable, attainable and relevant as well.
      MESSAGE
    end

    # Ask the user for the goal to be more specific
    def make_goal_specific(goal)
      system "clear"
      puts <<~MESSAGE 
        At the moment your goal is still very raw. You need your goal to be specific
        so you can have a better idea of what your end goal is. For example if your
        current goal is 'lose weight', it's not specific enough so you won't know
        exactly what you're working towards. A better goal is 'get to 12% body-fat in
        6 months'. And then to have a series of tasks to complete to get there.
        We will guide you through that later."
      MESSAGE
      description = CLI.ask("\nFor now, try and rewrite your goal so it meets this\nSMART criteria as best you can.\n\nDescribe your Goal:\n")
      goal.description = description if description
    end

    # Ask if the goal is Attainable
    def make_goal_attainable(goal)
      system "clear"
      puts "\nIs your goal Attainable? Or is your goal too easy? Or it set at the right level?"
      attainable = CLI.ask("\nPlease write out why you think your goal is set at the right level.")
      goal.attainable = attainable
    end

    # Ask if the goal is Relevant
    def make_goal_relevant(goal)
      system "clear"
      puts "\nIs your goal Relevant? Why is this goal important to you?"
      relevant = CLI.ask("\nPlease write out why you'd like to achieve this goal.")
      goal.relevant = relevant
    end

    # Ask for the user's friend's email address
    def set_friend_email
      puts <<~MESSAGE        
        We will now go even further and implement steps that make achieving your goals virtually
        inevitable.

        Goals that you're accountable to someone to achieve are much more likely to be met than
        those where there isn't external pressure.
      MESSAGE
      @friend_name = CLI.ask("\nPlease enter the name of someone that you don't want to let down.\nWe will let them know if you failed to achieve your goals and get them to hassle you.")
      email = CLI.ask("\nPlease enter his/her email:") do |q|
        q.validate = Helpers.valid_email?
        q.responses[:not_valid] = "\nInvalid email entered. Please enter a valid email."
      end
      @friend_email = email
    end

    # Complete setting the goal
    def finish_setting_goal
      system "clear"

      # Tell the user they did a good job
      puts <<~MESSAGE 
        Awesome, that's great. Good job on turning your original goal into a SMART goal!
        You're welcome to go back at any time to add more tasks or goals you want to achieve.
      MESSAGE

      # Press enter to finish
      CLI.ask("\nPress enter to finish.")
    end

    # Display list of goals
    def display_goals(operation)
      system "clear"
      if @goals.empty?
        choice = CLI.agree("You haven't set any goal yet. Set a goal now? (y/n)")
        if choice # if yes
          create_goal
        end

      else
        # Create new hash for goals
        goals = {}
        
        # Display list of goals
        @goals.each_with_index do |goal, index|
          goals["#{index + 1}. #{goal.description}"] = goal
        end

        # Ask the user to select a goal
        goal = PROMPT.select("Select a goal to #{operation}:", goals)
      end
      goal
    end

    # View list of goals
    def view_goals
      system "clear"
      
      # Display goals menu
      goal = display_goals("view")

      # If goal was set
      if !goal.nil?
        goal.display_task_management_menu # Display task management menu
      else
        # Just go back to main menu
      end
    end

    # Edit a goal
    def edit_goal
      system "clear"

      # Display goals menu
      goal = display_goals("edit")

      # If goal was set
      if !goal.nil?
        loop do
          system "clear"

          # Create attributes Hash to display goal describe and target date
          attributes = {
            "Description: #{goal.description}": :description,
            "Target Date: #{goal.target_date.strftime('%d/%m/%Y')}": :target_date,
            "Back": :back
          }
          # Display: Select which attribute to edit
          attribute = PROMPT.select("Select which attribute to edit", attributes)
          if attribute == :description  # User selects description
            description = CLI.ask("Enter new description")
            goal.description = description

          elsif attribute == :target_date # User selects target date
            target_date = Date.strptime(CLI.ask("Enter new target date"), '%d-%m-%Y')
            goal.target_date = target_date

          elsif attribute == :back  # User decides to press back
            break
          end

          # Edit another attribute, otherwise go back to main menu
          break unless CLI.agree("Edit another attribute? (y/n)")
        end

      else
        # Just go back to main menu
      end
    end

    # Delete a goal
    def delete_goal
      system "clear"

      # Display Loop: Ask the user which goal to delete
      loop do
        goal = display_goals("delete")

        # If goal was set
        if !goal.nil?
          @goals.delete(goal)
          break unless CLI.agree("Delete another goal? (y/n)")
        else
          # Just go back to main menu
          break
        end
      end
    end
  end
end