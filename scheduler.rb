module SmartGoals
  class Scheduler
    attr_accessor :schedule   # scheduler : Rufus::Scheduler
    attr_accessor :popup      # popup : Popup
    attr_accessor :email      # email : Email

    # How to describe it
    def initialize
      @schedule = Rufus::Scheduler.new
      @popup = Popup.new
      @email = Email.new
    end

    # Schedule a popup message
    def schedule_popup(message, notification_time)
      @schedule.at notification_time.to_s do
        @popup.send_popup(message)
        @schedule.shutdown
      end
    end

    # Schedule an email message
    def schedule_email(email, message, notification_time)
      @schedule.at notification_time.to_s do
        @email.send_email(email, message)
        @schedule.shutdown
      end
    end
  end
end
