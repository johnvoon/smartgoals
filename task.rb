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
      @status = :todo # Default status is set to :todo
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

    # Create a scheduled reminder
    def create_reminder_notification
      scheduler = Scheduler.new
      # Calculate remainder time
      reminder_time = case self.frequency
                      when :every_minute then self.target_date - 30
                      when :hourly then self.target_date - (60 * 30)
                      else self.target_date - (60 * 60 * 24)
                      end
      
      # Set the reminder message
      message = "Hey #{GOALSETTER.name}, this is a reminder for you to: #{self.description.uncolorize}"

      # Schedule a popup message
      scheduler.schedule_popup(message, reminder_time)

      # Schedule an email message
      scheduler.schedule_email(GOALSETTER.email, message, reminder_time)
    end

    # Create a scheduled fail notification
    def create_failed_notification
      
      scheduler = Scheduler.new
      
      # Set the failed message
      user_message = "Hey #{GOALSETTER.name}, You did not #{self.description.uncolorize} today."

      # Set the failed email message
      user_email = <<~MESSAGE
        Hey #{GOALSETTER.name}, 
        
        You did not #{self.description} today to achieve your goal: . 
        
        If you want to achieve your goal, you'll need to take steps to get there. Keep going!
        
        The Smart Goals Team        
      MESSAGE

      # Set the failed email message for user's friend
      friend_email = <<~MESSAGE
        Hey #{GOALSETTER.friend_name}, 
        
        Your friend #{GOALSETTER.name} wants to achieve this goal:

        He/she told us to notify you on failing to do a task to meet this goal. 
        
        Let them know they're failing at this task: #{self.description}.

        Thanks.

        The Smart Goals Team
      MESSAGE
      
      # Set the color change to red for failure
      scheduler.schedule_color_change_by_status(@target_date, self, :failed)

      # Set the reminder message
      scheduler.schedule_popup(user_message, self.target_date)
      
      # Schedule an email message
      scheduler.schedule_email(GOALSETTER.email, user_email, self.target_date)

      # Schedule an email message for user's friend
      scheduler.schedule_email(GOALSETTER.friend_email, friend_email, self.target_date)
    end
  end
end
