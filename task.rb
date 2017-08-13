# Purpose: To contain the attributes of the tasks
module SmartGoals
  class Task
    # What it has
    attr_accessor :description
    attr_accessor :start_time
    attr_accessor :creation_date
    attr_accessor :target_date
    attr_accessor :completion_date
    attr_accessor :status # Symbol :todo :completed :failed
    attr_accessor :frequency # Symbol :once :daily :weekly :monthly :yearly
    attr_accessor :notifications
    attr_accessor :goal

    # How to describe it
    def initialize
      @status = :todo # Status is set to a "todo" upon creation
    end

    # TODO
    # send_message - reminder, notification, encouragement

    def create_reminder_notification
      notification_service = Scheduler.new
      reminder_time = case self.frequency
                      when :every_minute then self.target_date - 30
                      when :hourly then self.target_date - (60 * 30)
                      else self.target_date - (60 * 60 * 24)
                      end
      message = "Hey #{GOALSETTER.name}, this is a reminder for you to: #{@description}"
      notification_service.schedule_popup(message, reminder_time)
      notification_service.schedule_email(GOALSETTER.email, message, reminder_time)
    end

    def create_failed_notification
      notification_service = Scheduler.new
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
      notification_service.schedule_popup(user_message, @target_date)
      notification_service.schedule_email(GOALSETTER.email, user_email, @target_date)
      notification_service.schedule_email(GOALSETTER.friend_email, friend_email, @target_date)
    end
  end
end
