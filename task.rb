# Purpose: To contain the attributes of the tasks
module SmartGoals
  class Task
    # What it has
    attr_accessor :description     # description : String
    attr_accessor :start_time      # start_time  : Time
    attr_accessor :creation_date   # creation_date : Time
    attr_accessor :target_date     # target_date : Time
    attr_accessor :completion_date # completion_date : Time
    attr_accessor :status          # Symbol :todo :completed :failed
    attr_accessor :frequency       # Symbol :once :daily :weekly :monthly :yearly
    attr_accessor :notifications   # ?
    attr_accessor :goal            # goal : Goal

    # How to describe it
    def initialize
      @status = :todo # Status is set to a "todo" upon creation
    end

    # Create a scheduled reminder
    def create_reminder_notification
      scheduler = Scheduler.new
      reminder_time = case self.frequency
                      when :every_minute then self.target_date - 30
                      when :hourly then self.target_date - (60 * 30)
                      else self.target_date - (60 * 60 * 24)
                      end
      message = "Hey #{GOALSETTER.name}, this is a reminder for you to: #{@description}"
      scheduler.schedule_popup(message, reminder_time)
      scheduler.schedule_email(GOALSETTER.email, message, reminder_time)
    end

    # Create a scheduled fail notification
    def create_failed_notification
      scheduler = Scheduler.new
      user_message = "Hey #{GOALSETTER.name}, You did not #{@description} today."
      user_email = <<~MESSAGE
        Hey #{GOALSETTER.name}, 
        
        You did not #{@description} today to achieve your goal: . 
        
        If you want to achieve your goal, you'll need to take steps to get there. Keep going!
        
        The Smart Goals Team        
      MESSAGE
      friend_email = <<~MESSAGE
        Hey #{GOALSETTER.friend_name}, 
        
        Your friend #{GOALSETTER.name} wants to achieve this goal:

        He/she told us to notify you on failing to do a task to meet this goal. 
        
        Let them know they're failing at this task: #{@description}.

        Thanks.

        The Smart Goals Team
      MESSAGE

      scheduler.schedule_popup(user_message, @target_date)
      scheduler.schedule_email(GOALSETTER.email, user_email, @target_date)
      scheduler.schedule_email(GOALSETTER.friend_email, friend_email, @target_date)
    end
  end
end
