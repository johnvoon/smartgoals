# Purpose: To create a schedule
module SmartGoals
  class Scheduler
    attr_accessor :id
    attr_accessor :schedule   # scheduler : Rufus::Scheduler
    attr_accessor :type # the type of scheduler
    # How to describe it
    def initialize
      @id = SecureRandom.uuid
      @schedule = Rufus::Scheduler.new
    end

    def schedule_failed_status_change(task, notification_time)
      @schedule.at notification_time.to_s do
        task.status = :failed
        @schedule.shutdown
      end
    end

    # Schedule a popup message
    def schedule_popup(message, notification_time)
      popup = Popup.new
      @schedule.at notification_time.to_s do
        popup.send_popup(message)
        @schedule.shutdown
      end
    end

    # Schedule an email message
    def schedule_email(email_address, message, notification_time)
      email = Email.new
      @schedule.at notification_time.to_s do
        email.send_email(email_address, message)
        @schedule.shutdown
      end
    end
    
  end
end
