# Purpose: To Create Goals
module SmartGoals
  class GoalSetter
    # What it has
    # goals : Array of Goal
    attr_accessor :name
    attr_accessor :email
    attr_accessor :friend_name
    attr_accessor :friend_email
    attr_accessor :goals

    # How to describe it
    def initialize
      @goals = []
    end

    def run_program
      welcome_screen
      get_goal_management_choice
    end

    # What can it do
    # TODO
    # add_goal
    # remove_goal

    def welcome_screen
      system "clear"
      puts "Welcome to SMART Goals!"

      @name = CLI.ask("\nWhat's your name?")
      @email = CLI.ask("\nWhat's your email? This is where we'll be sending you notifications.") do |q|
        q.validate = Helpers.valid_email?
        q.responses[:not_valid] = "\nInvalid email entered. Please enter a valid email."
      end
    end

    def get_goal_management_choice
      loop do
        system "clear"
        puts "\nHi #{@name}! We'll be guiding you through the process of setting SMART goals."

        choice = PROMPT.select("\nIf you're new, select 'Create a SMART Goal'.") do |menu|
          menu.choice 'Create a SMART Goal', '1'
          menu.choice 'View a SMART Goal', '2'
          menu.choice 'Edit a SMART Goal', '3'
          menu.choice 'Delete a SMART Goal', '4'
          menu.choice 'Exit', '5'
        end

        case choice
        when '1'
          create_goal
        when '2'
          view_goals
        when '3'
          edit_goal
        when '4'
          delete_goal
        when '5'
          break
        end
      end
    end

    def create_goal
      system "clear"
      goal = Goal.new
      goal.description = CLI.ask("Please tell us your goal. Don't worry about it too much at this point. We are just trying to get a base direction and will refine it later.")
      puts <<~MESSAGE
        
        Thanks for telling us your goal! 
        
        Welcome to the Goal Refinement Centre. As you go through this process, you will see your vague unspecific goal transform into something specific and actionable. You will know exactly what your goal is and the specific tasks you need to complete to get there. You can imagine your goal now as piece of raw steel but by the time you go through this process it will be forged into a sword.
      
        Let's start out by setting an target date for achieving your goal. If you don't set a target date, your goal will just remain a fantasy. Setting a target date for your goal is important step in the SMART goal process.
      MESSAGE
      
      target_date = CLI.ask("\nPlease enter a target date (format: dd-mm-yyyy)") do |q|
        q.validate = Helpers.valid_date?
        q.responses[:not_valid] = "Please enter a date in the future."
        q.responses[:invalid_type] = "Please enter a valid date."
      end

      goal.target_date = Date.strptime(target_date, "%d-%m-%Y")
      list_smart_words
      make_goal_specific(goal)
      make_goal_attainable(goal)
      make_goal_relevant(goal)
      set_friend_email
      goal.create_tasks
      @goals << goal
      finish_setting_goal
    end

    def list_smart_words
      system "clear"
      puts <<~MESSAGE
        
        Now that we've set a target date, let's make your goals SMART:

        - Specific
        - Measurable
        - Attainable
        - Relevant
        - Timely

        You've already made your goal timely in the previous step. However you'll need to make your goal specific, measurable, attainable and relevant as well.
      MESSAGE
    end

    def make_goal_specific(goal)
      system "clear"
      puts "\nAt the moment your goal is still very raw. You need your goal to be specific so you can have a better idea of what your end goal is. For example if your current goal is 'lose weight', it's not specific enough so you won't know exactly what you're working towards. A better goal is 'get to 12% body-fat in 6 months'. And then to have a series of tasks to complete to get there. We'll guide you through that later."
      description = CLI.ask("\nFor now, try and rewrite your goal so it meets this SMART criteria as best you can.")
      goal.description = description if description
    end

    def make_goal_attainable(goal)
      system "clear"
      puts "\nIs your goal Attainable? Or is your goal too easy? Or it set at the right level?"
      attainable = CLI.ask("\nPlease write out why you think your goal is set at the right level.")
      goal.attainable = attainable
    end

    def make_goal_relevant(goal)
      system "clear"
      puts "\nIs your goal Relevant? Why is this goal important to you?"
      relevant = CLI.ask("\nPlease write out why you'd like to achieve this goal.")
      goal.relevant = relevant
    end

    def set_friend_email
      puts <<~MESSAGE        
        We will now go even further and implement steps that make achieving your goals virtually inevitable.

        Goals that you're accountable to someone to achieve are much more likely to be met than those where there isn't external pressure.
      MESSAGE
      @friend_name = CLI.ask("\nPlease enter the email of someone that you don't want to let down. We will let them know if you failed to achieve your goals and get them to hassle you.")
      email = CLI.ask("\nPlease enter his/her email:") do |q|
        q.validate = Helpers.valid_email?
        q.responses[:not_valid] = "\nInvalid email entered. Please enter a valid email."
      end
      @friend_email = email
    end

    def finish_setting_goal
      system "clear"
      puts "\nAwesome, that's great. Good job on turning your original goal into a SMART goal! You're welcome to go back at any time to add more tasks or goals you want to achieve."
      CLI.ask("\nPress enter to finish.")
    end

    def display_goals(operation)
      system "clear"
      if @goals.empty?
        choice = CLI.agree("You haven't set any goal yet. Set a goal now? (y/n)")
        if choice
          create_goal
        end
      else
      goals = {}
      @goals.each_with_index { |goal, index| goals["#{index + 1}. #{goal.description}"] = goal }
      goal = PROMPT.select("Select a goal to #{operation}:", goals)
      end
      goal
    end

    def view_goals
      system "clear"
      goal = display_goals("view")
      goal.display_task_management_menu
    end

    def edit_goal
      system "clear"
      goal = display_goals("edit")
      loop do
        system "clear"
        attributes = {
          "Description: #{goal.description}": :description,
          "Target Date: #{goal.target_date.strftime('%d/%m/%Y')}": :target_date,
          "Back": :back
        }
        attribute = PROMPT.select("Select which attribute to edit", attributes)
        if attribute == :description
          description = CLI.ask("Enter new description")
          goal.description = description
        elsif attribute == :target_date
          target_date = Date.strptime(CLI.ask("Enter new target date"), '%d-%m-%Y')
          goal.target_date = target_date
        elsif attribute == :back
          break
        end
        break unless CLI.agree("Edit another attribute? (y/n)")
      end
    end

    def delete_goal
      system "clear"
      loop do
        goal = display_goals("delete")
        @goals.delete(goal)
        break unless CLI.agree("Delete another goal? (y/n)")
      end
    end
  end
end