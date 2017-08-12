# Purpose: To contain the attributes of the tasks
# Usage:
#   t = SmartGoals::Task.new
#   t.frequency = :every_minute
#   t.description = 'Learn Ruby'
#   t.target_time = Time.parse('2017/08/11 16:20:00 +10:00')
#   t.create_reminder_notification
#   t.create_failed_notification]

module SmartGoals
  class Task
    # What it has
    # description : String
    # start_time : Time
    # target_time : Time
    # mark_complete : Boolean
    # completion_date : Time
    # status : Symbol :todo :completed :failed
    # frequency : Symbol :once :daily :weekly :monthly :annualy
    # notifications : Array of NotificationService

    attr_accessor :description
    attr_accessor :start_time
    attr_accessor :target_time
    attr_accessor :mark_complete
    attr_accessor :completion_date
    attr_accessor :status
    attr_accessor :frequency
    attr_accessor :notifications

    # How to describe it
    def initialize
        @status = :todo # Default status is set to a "todo" upon creation
        @start_time = Time.now.getlocal
        @frequency = frequency
        @notifications = []
    end

    # What can it do
    # Create notifications
    def create_reminder_notification
      #puts "Creating reminder notification"
      @reminder = NotificationService.new
      
      #For demo purposes
      #reminder_time = self.get_reminder_hour(@target_time, 1) # Target Time minus 1 hour
      reminder_time = self.get_reminder_minute(@target_time, 1) # Target Time minus 1 minute

      message = "This is a reminder for your task: #{@description}"
      @reminder.create_notification_service(message, @start_time, reminder_time)
      @notifications << @reminder
    end

    # Failed notification (Target time was met)
    def create_failed_notification
        #puts "Creating failed notification"
        @failed_message = NotificationService.new
        message = "You failed to achieve your task: #{@description}"
        @failed_message.create_notification_service(message, @start_time, @target_time)
        @notifications << @failed_message
    end

    # Get reminder minute before target time
    def get_reminder_minute(time, before_minutes)
      (time.to_datetime - (before_minutes/1440.0)).to_time
    end

    # Get reminder hour before target time
    def get_reminder_hour(time, before_hours)
      (time.to_datetime - (before_hours/24.0)).to_time
    end

    # Cancel all notifications (Just in case it is needed)
    def remove_notifications
      @notifications.each do |notification|
        notification.stop_notification_service
      end
    end
  end
end


# module SmartGoals
#   class Task
#     # What it has
#     # id : Integer  - To identify the task uniquely
#     # description : String
#     # start_date : DateTime
#     # target_date : DateTime
#     # mark_complete : Boolean
#     # completion_date : DateTime
#     # status : Symbol :todo :completed :failed
#     # frequency : Symbol :off :daily :weekly :monthly :annual
#     # reminder_date : DateTime
#     # reminder : String
#     attr_accessor :description
#     attr_accessor :creation_date
#     attr_accessor :target_date
#     attr_accessor :mark_complete
#     attr_accessor :completion_date
#     attr_accessor :status
#     attr_accessor :frequency
#     attr_accessor :reminder_date
#     attr_accessor :reminder

#     # How to describe it
#     def initialize(task)
#         @description = task[:description]  
#         @status = :todo # Status is set to a "todo" upon creation
#         @frequency = task[:frequency] || :off
#         @target_date = task[:target_date]
#     end

#     # What can it do
#     # TODO
#     # send_message - reminder, notification, encouragement

#   end
# end