# Purpose: To contain the attributes of the tasks
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
  # TODO
  # send_message - reminder, notification, encouragement
  
  # 1 hour before (end time minus 1 hour)
  def create_reminder_notification
    puts "Creating reminder notification"
    @reminder = NotificationService.new
    
    #reminder_time = self.get_reminder_hour(@target_time, 1) # Target Time minus 1 hour
    
    #For demo purposes
    reminder_time = self.get_reminder_minute(@target_time, 1) # Target Time minus 1 minute

    message = "This is a reminder for your task: #{@description}"
    @reminder.create_notification_service(message, @start_time, reminder_time, @frequency)
    @notifications << @reminder
  end
  
  # Get reminder minute before target time
  def get_reminder_minute(time, before_minutes)
    (time.to_datetime - (before_minutes/1440.0)).to_time
  end

  # Get reminder hour before target time
  def get_reminder_hour(time, before_hours)
    (time.to_datetime - (before_hours/24.0)).to_time
  end

  # Failed notification (end time met)
  def create_failed_notification
      puts "Creating failed notification"
      @failed_message = NotificationService.new
      message = "You failed to achieve your task: #{@description}"
      @failed_message.create_notification_service(message, @start_time, @target_time, @frequency)
      @notifications << @failed_message
  end

  # Cancel all notifications
  def remove_notifications
    @notifications.each do |notification|
      notification.cancel_notification_service
    end
  end

end