# Purpose: To create a schedule
module SmartGoals
  class Scheduler
    attr_accessor :schedule   # scheduler : Rufus::Scheduler

    # How to describe it
    def initialize
      @schedule = Rufus::Scheduler.new
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
    def schedule_email(email, message, notification_time)
      email = Email.new
      @schedule.at notification_time.to_s do
        email.send_email(email, message)
        @schedule.shutdown
      end
    end
  end
end
