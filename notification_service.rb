module SmartGoals
  class NotificationService
    attr_accessor :scheduler
    attr_accessor :task

    def initialize
      @scheduler = Rufus::Scheduler.new
    end

    def schedule_popup(message, notification_time)
      @scheduler.at notification_time.to_s do
        send_popup(message)
        @scheduler.shutdown
      end
    end

    def schedule_failure(notification_time, task)
      @task = task
      @scheduler.at notification_time.to_s do
        @task.status_color = :failed
        @scheduler.shutdown
      end
    end

    def schedule_email(email, message, notification_time)
      @scheduler.at notification_time.to_s do
        # send_email(email, message)
        @scheduler.shutdown
      end
    end

    def send_popup(message)
      if OS.mac?
        system("echo '#{message}' | terminal-notifier -sound default")
      elsif OS.linux?
        system("notify-send '#{message}'")
      elsif OS.windows?
        # TODO
        # If windows
      end
    end

    # def send_email(email, message)
    #   options = {
    #     :address              => "smtp.gmail.com",
    #     :port                 => 587,
    #     :domain               => 'your.host.name',
    #     :user_name            => 'tellyourbuddytouptheirgame@gmail.com',
    #     :password             => 'UpYourGame',
    #     :authentication       => 'plain',
    #     :enable_starttls_auto => true
    #   }

    #   Mail.defaults do
    #     delivery_method :smtp, options
    #   end

    #   Mail.deliver do
    #     to email
    #     from 'tellyourbuddytouptheirgame@gmail.com'
    #     subject 'SmartGoals Notifications'
    #     body message
      # end
    # end
  end
end
