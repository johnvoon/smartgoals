# Purpose: To Create Goals
module SmartGoals
  class GoalSetter
    # What it has
    attr_accessor :name         # name : String
    attr_accessor :email        # email : String
    attr_accessor :friend_name  # friend_name : String
    attr_accessor :friend_email # friend_email :  String
    attr_accessor :goals        # goals : Array of Goal
    attr_reader   :question     # question: Questions

    # How to describe it
    def initialize
      @goals = []
      @question = Question.new
    end

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
      @name = @question.ask_for_name("\nWhat's your name?")

      # Ask for the user's email
      @email = @question.ask_for_email("\nWhat is your email? This is where we will be sending you notifications.")
    end

    # Display the menu choices
    def get_goal_management_choice
      loop do
        system "clear"

        # Make the user feel welcome
        puts "\nHi #{self.name}! We will be guiding you through the process of setting SMART goals."

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
      if CLI.agree("Create a new goal? (y/n)")
        goal = Goal.new

        # Ask the user for his Goal but not to worry about it too much at this point
        goal.description = @question.ask_for_description("\nPlease tell us your goal. Don't worry about it too much at this point.\nWe are just trying to get a base direction and will refine it later.\n\nDescribe your Goal:\n")

        # The goal description has been set. Thank the user. Tell him more about the app.
        puts <<~MESSAGE

          Thanks for telling us your goal!

          Welcome to the Goal Refinement Centre. As you go 
          through this process, your goal will be transformed 
          from something vague into something specific and 
          actionable. You'll know exactly what your goal is 
          and the specific tasks you need to complete to get there. 
          You can imagine your goal now as a piece of raw steel 
          but by the time you go through this process it will be
          forged into a sword.

          Let's start out by setting a target date for achieving 
          your goal. If you don't set this, your goal will remain 
          a fantasy.
        MESSAGE

        # Ask the user for a target date in dd-mm-yyyy format
        goal.target_date = @question.ask_for_target_date("\nWhen would you like to achieve this Goal? (format: dd-mm-yyyy)")

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

        system "clear"
        puts <<~MESSAGE

          At the moment your goal is still too big and daunting 
          to be achieved. So we will need to break your goal 
          down into a series of tasks.
          
          Make sure these tasks also meet the SMART criteria.
        MESSAGE

        CLI.ask("\nPress enter to continue.")

        # Display: Create the tasks
        if CLI.agree("\nDo you want to set tasks now (y/n)?")
          goal.create_tasks
          finish_setting_goal
        else
          finish_setting_goal_without_tasks
        end

        @goals << goal

        # Display: Complete setting the goal
      end
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
      CLI.ask("\nPress enter to continue.")
    end
    # Ask the user for the goal to be more specific
    def make_goal_specific(goal)
      system "clear"
      puts <<~MESSAGE

        YOUR CURRENT GOAL: #{goal.description}

        At the moment, your goal may still be quite vague.

        It needs to be SPECIFIC so you have a better idea of what
        you're trying to achieve.

        For example, a goal 'to lose weight' is not specific enough.

        A better goal would be 'get to 12% body-fat in 6 months'.
      MESSAGE
      # Ask for a more specific goal description
      goal.description = @question.ask_for_description("\nRe-write your Goal to be more Specific:\n")
    end

    # Ask if the goal is Attainable
    def make_goal_attainable(goal)
      system "clear"
      puts <<~MESSAGE

        Is your goal ATTAINABLE?
        Or is it too easy?

        Please write out why you think your goal is set at the right level.
      MESSAGE
      # Ask for an ATTAINABLE description
      goal.attainable = @question.ask_for_description("\nDescribe why your goal is Attainable:\n")
    end

    # Ask if the goal is Relevant
    def make_goal_relevant(goal)
      system "clear"
      puts <<~MESSAGE

        Is your goal RELEVANT?
        Why is this goal important to you?

        Please write why you'd like to achieve this goal.
      MESSAGE
      # Ask for RELEVANT description
      goal.relevant = @question.ask_for_description("\nDescribe why your goal is Relevant:\n")
    end

    # Ask for the user's friend's email address
    def set_friend_email
      system "clear"
      puts <<~MESSAGE

        We will now go even further and implement steps that
        make achieving your goal virtually inevitable.

        It's easier to achieve your goals if you have someone
        to motivate you.

        Please enter the name of someone you don't want to
        let down.

        We'll let them know if you've failed to achieve your
        goals and get them to keep you going.
      MESSAGE

      @friend_name = @question.ask_for_name("\nFriend's name:")
      @friend_email = @question.ask_for_email("\nPlease enter #{self.friend_name}'s email:")
    end

    # Complete setting the goal
    def finish_setting_goal
      system "clear"

      # Tell the user they did a good job
      puts <<~MESSAGE

        Good job on turning your original goal into a SMART goal!
        You're welcome to go back later and add more tasks or goals.
      MESSAGE

      # Press enter to finish
      CLI.ask("\nPlease press enter to finish.")
    end

    # Complete setting the goal without tasks
    def finish_setting_goal_without_tasks
      system "clear"

      # Tell the user they did a good job
      puts <<~MESSAGE

        Good job on turning your goal into a SMART goal!
        However, you have 1 more step to go: Setting your tasks!
      MESSAGE

      # Press enter to finish
      CLI.ask("\nPress enter to go back to the main menu.")
    end

    # Display list of goals
    def get_goal_choice(operation)
      system "clear"
      if @goals.empty?
        if CLI.agree("You haven't set any goal yet. Set a goal now? (y/n)")
          create_goal
          return
        end
      else
        # Create new hash for goals
        goals = {}

        # Display list of goals
        @goals.each_with_index do |goal, index|
          goals["#{index + 1}. #{goal.description}"] = goal
        end

        goals["#{goals.length + 1}. Back"] = :back

        # Ask the user to select a goal
        goal = PROMPT.select("Select a goal to #{operation}:", goals)
        goal
      end
    end

    # View list of goals
    def view_goals
      system "clear"

      # Display goals menu and get goal choice
      goal = get_goal_choice("view")
      
      # If goal was set
      if goal && goal != :back
        goal.display_task_management_menu # Display task management menu
      end
    end

    # Edit a goal
    def edit_goal
      system "clear"

      # Display goals menu
      goal = get_goal_choice("edit")

      # If goal was set
      if goal && goal != :back
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
            goal.description = @question.ask_for_description("Please enter new description")

          elsif attribute == :target_date # User selects target date

            # Ask the user for a new target date in dd-mm-yyyy format
            goal.target_date = @question.ask_for_target_date("\nPlease enter a new target date (format: dd-mm-yyyy)")

          elsif attribute == :back  # User decides to press back
            break
          end

          # Edit another attribute, otherwise go back to main menu
          break unless CLI.agree("Edit another attribute? (y/n)")
        end
      end
    end

    # Delete a goal
    def delete_goal
      system "clear"
      # Display Loop: Ask the user which goal to delete
      goal = get_goal_choice("delete")
      if goal && goal != :back
        loop do
          @goals.delete(goal)
          break unless CLI.agree("Delete another goal? (y/n)")
        end
      end
    end
  end
end