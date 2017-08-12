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

    # How to describe it
    def initialize
      @status = :todo # Status is set to a "todo" upon creation
    end

    # What can it do
    # TODO
    # send_message - reminder, notification, encouragement

    def create_reminder_notification
      scheduler = Scheduler.new
      reminder_time = case self.frequency
                      when :every_minute then self.target_date - 55
                      when :hourly then self.target_date - (60 * 30)
                      else self.target_date - (60 * 60 * 24)
                      end
      message = "Hey #{GOALSETTER.name}, this is a reminder for you to: #{@description}"
      scheduler.schedule_notification(message, reminder_time)
    end

    def create_failed_notification
      scheduler = Scheduler.new
      message = "Hey #{GOALSETTER.name}, you did not #{@description}!"
      scheduler.schedule_notification(message, @target_date)
    end

    def schedule_recurring_task_creation(goal)
      scheduler = Scheduler.new
      scheduler.schedule_task_creation(goal, self, @target_date)
    end
  end
end
