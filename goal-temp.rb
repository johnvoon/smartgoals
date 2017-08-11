require 'pry'
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
      goal.description = CLI.ask('What goal would you like to achieve?')
      goal.target_date = Date.strptime(CLI.ask('When do you aim to achieve this goal by?'), "%d-%m-%Y")
      goal.set_tasks
      @goals << goal
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
      display_goals("view")
      # view tasks
      # add task
      # remove task
      # edit task      
    end

    def edit_goal
      system "clear"
      goal = display_goals("edit")
      loop do
        system "clear"
        attributes = {
          "Description: #{goal.description}": :description,
          "Target Date: #{goal.target_date.strftime('%d/%m/%Y')}": :target_date
        }
        attribute = PROMPT.select("Select which attribute to edit", attributes)
        if attribute == :description
          description = CLI.ask("Enter new description")
          goal.description = description
        elsif attribute == :target_date
          target_date = Date.strptime(CLI.ask("Enter new target date"), '%d-%m-%Y')
          goal.target_date = target_date
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