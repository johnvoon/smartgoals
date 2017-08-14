# Purpose:
# To create a notification service that allows the user see reminders on their computer
# Compatibility
# Mac, Linux (soon Windows)

class NotificationService
  
  attr_accessor :schedule

  # How to describe it
  def initialize
    @scheduler = Rufus::Scheduler.new
  end

  # What can it do
  # create notification service
  # message: String
  # start_time: Time
  # notification_time: Time
  def create_notification_service(message, start_time, notification_time)

    #puts "Message should fire up at #{notification_time.to_s}"
      
    @scheduler.at notification_time.to_s do #e.g. at '2017/08/10 18:50:00 +10:00' do

      # Send notification message
      self.send_notification(message)
      # Shutdown scheduler immediately after the notification has been sent to the user
      @scheduler.shutdown
    end

    # Don't use @scheduler.join to keep thread in background
    #@scheduler.join # Adds the scheduler to the scheduler thread
    
  end

  # Send notification message
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

  # Stop notification service - In the event that we need to cancel the notification service outside the class
  def stop_notification_service
    @scheduler.shutdown # Kills the notification service
  end
end


### Stuff that can be added later on

  # # Get Frequency String
  # def get_frequency_string(start_time, frequency)
  #   frequency_string = ''
  #   case frequency
  #     when :every_minute
  #       frequency_string = '1m'
  #     when :hourly
  #       frequency_string = '1h'
  #     when :daily
  #       frequency_string = '1d'
  #     when :weekly
  #       frequency_string = '1w'
  #     when :monthly
  #       frequency_string = "#{get_days_to_next_month(start_time)}d"
  #     when :annualy
  #       frequency_string = "#{get_days_to_next_year(start_time)}d"
  #     else
  #       frequency_string = 'invalid'
  #   end
  #   frequency_string
  # end

  # # Get days to next month
  # def get_days_to_next_month(start_time)
  #     start_datetime = start_time.to_datetime
  #     end_datetime = start_datetime >> 1
  #     days = (end_datetime - start_datetime).to_i
  # end

  # # Get days to next year
  # def get_days_to_next_year(start_time)
  #     start_datetime = start_time.to_datetime
  #     end_datetime = start_datetime >> 12
  #     days = (end_datetime - start_datetime).to_i
  # end

  # # Get First At Time - Time when the Notification first fires off
  # def get_first_time(start_time, frequency)
  #   case frequency
  #     when :every_minute
  #       (start_time.to_datetime + (1/1440.0)).to_time # 1 minute
  #     when :hourly
  #       (start_time.to_datetime + (1/24.0)).to_time # 1 hour
  #     when :daily
  #       (start_time.to_datetime + 1.0).to_time # 1 day
  #     when :weekly
  #       (start_time.to_datetime + 7.0).to_time # 1 week
  #     when :monthly
  #       (start_time.to_datetime + get_days_to_next_month(start_time).to_f).to_time # 1 month
  #     when :annualy
  #       (start_time.to_datetime + get_days_to_next_year(start_time).to_f).to_time # 1 year
  #   end
  # end