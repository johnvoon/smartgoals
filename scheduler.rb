module SmartGoals
  class Scheduler
    attr_accessor :scheduler, :sent

    def initialize
      @scheduler = Rufus::Scheduler.new
    end

    def schedule_notification(message, notification_time) 
      @scheduler.at notification_time.to_s do
        send_notification(message)
        @scheduler.shutdown
      end
    end

    def schedule_task_creation(goal, current_task, notification_time)
      @scheduler.at notification_time.to_s do
        new_task = Task.new
        new_task.description = current_task.description
        new_task.frequency = current_task.frequency
        new_task.creation_date = Time.now.getlocal
        new_task.target_date = Helpers.calculate_task_target_date(
          current_task.creation_date,
          current_task.frequency
        )

        new_task.create_reminder_notification
        new_task.create_failed_notification
        new_task.schedule_recurring_task_creation(self)
        puts "New task created"
        @scheduler.shutdown
      end
    end

    def send_notification(message)
      if OS.mac?
        system("echo '#{message}' | terminal-notifier -sound default")
      elsif OS.linux?
        system("notify-send '#{message}'")
      elsif OS.windows?
        # TODO
        # If windows
      end
    end

    def send_email
    end
  end
end
