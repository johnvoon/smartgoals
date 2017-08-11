# Purpose: To Create Goals
module SmartGoals
  class GoalSetter
    # What it has
    # goals : Array of Goal
    attr_accessor :goals

    # How to describe it
    def initialize
      @goals = []
    end

    def run_program
      loop do
        system "clear"
        puts <<~MESSAGE
          Welcome to SMART Goals! We'll be guiding you through the process of setting SMART goals.

        MESSAGE
        choice = SmartGoals::PROMPT.select("What would you like to do?") do |menu|
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

    # What can it do
    # TODO
    # add_goal
    # remove_goal

    def create_goal
      system "clear"
      goal = Goal.new      
      goal.description = CLI.ask("Please Enter your goal. Don't worry about it too much at this point. We're just trying to get a base direction and will refine it later.")
      goal.set_tasks
      @goals << goal
    end

    def view_goals
      system "clear"
      if @goals.empty?
        choice = CLI.agree("You haven't set any goal yet. Set a goal now? (y/n)")
        if choice
          create_goal
        end
      else
        goals = {}
        @goals.each_with_index { |goal| goals["#{index + 1}"] = goal.description }
        goal = PROMPT.select("Select a goal to review:", goals)
      end
    end
  end
end