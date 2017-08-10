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
          Welcome to SMART Goals! We will guide you through the process of setting SMART goals.

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
          view_goal
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
      goal.description = CLI.ask('What goal would you like to achieve?')
      goal.set_tasks
    end

    def view_goal
      system "clear"
      
    end

    # What can it do
    # TODO
    # add_goal
    # remove_goal
  end
end