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

    # Change status and colorize
    def status_color=(status)
      @status = status
      puts status
      if @status == :completed
        self.description = self.description.colorize(:color => :black, :background => :green)
      elsif @status == :failed
        self.description = self.description.colorize(:red)
      else 
        self.description = self.description.colorize(:white)
      end
    end
    # What can it do
    # TODO
    # send_message - reminder, notification, encouragement

    def create_reminder_notification
      notification_service = NotificationService.new
      reminder_time = case self.frequency
                      when :every_minute then self.target_date - 30
                      when :hourly then self.target_date - (60 * 30)
                      else self.target_date - (60 * 60 * 24)
                      end
      # need uncolorize or it won't display popup properly
      message = "Hey #{GOALSETTER.name}, this is a reminder for you to: #{@description.uncolorize}" 
      notification_service.schedule_popup(message, reminder_time)
      notification_service.schedule_email(GOALSETTER.email, message, reminder_time)
    end

    def create_failed_notification
      # status is switched to :failed and passed to the schedule_failure function to change the text color when the time comes  
      
      
      notification_service = NotificationService.new
      user_message = "Hey #{GOALSETTER.name}, You did not #{@description.uncolorize} today."
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
      notification_service.schedule_failure(@target_date, self)
      notification_service.schedule_email(GOALSETTER.email, user_email, @target_date)
      notification_service.schedule_email(GOALSETTER.friend_email, friend_email, @target_date)
      
    end
  end
end
