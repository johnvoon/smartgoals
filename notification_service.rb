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
  # stop_schedule_now: Boolean (e.g. task has been completed or for one-off tasks)
  def create_notification_service(message, start_time, notification_time, frequency)

    puts "Message should fire up at #{notification_time.to_s}"
      
    
    if frequency == :once # If it only happens once
      puts "Inside Once"
      
      @scheduler.at notification_time.to_s do #e.g. at '2017/08/10 18:50:00 +10:00' do
      #@scheduler.every '3s', :first => :now do

        # Send notification message
        self.send_notification(message)
        # One off. Kill immediately
        @scheduler.shutdown
      end

    else
      puts "Inside Every"
      # Get frequency String for rufus compatibility
      frequency_string = get_frequency_string(start_time, frequency)

      # Get first time when the notification fires off
      first_time = get_first_time(start_time, frequency)

      if frequency_string != 'invalid'
        @scheduler.every frequency_string, :first_at => first_time.to_s do
          # Send notification message
          self.send_notification(message)

          # If end time has been reached
          if Time.now.getlocal.to_s == notification_time.to_s      
            @scheduler.shutdown
          end
        end
      end

    end
    # Don't use @scheduler.join to keep thread in background
    #@scheduler.join # Adds the scheduler to the scheduler thread
    
  end

  # Get Frequency String
  def get_frequency_string(start_time, frequency)
    frequency_string = ''
    case frequency
      when :every_minute
        frequency_string = '1m'
      when :hourly
        frequency_string = '1h'
      when :daily
        frequency_string = '1d'
      when :weekly
        frequency_string = '1w'
      when :monthly
        frequency_string = "#{get_days_to_next_month(start_time)}d"
      when :annualy
        frequency_string = "#{get_days_to_next_year(start_time)}d"
      else
        frequency_string = 'invalid'
    end
    frequency_string
  end

  # Get days to next month
  def get_days_to_next_month(start_time)
      start_datetime = start_time.to_datetime
      end_datetime = start_datetime >> 1
      days = (end_datetime - start_datetime).to_i
  end

  # Get days to next year
  def get_days_to_next_year(start_time)
      start_datetime = start_time.to_datetime
      end_datetime = start_datetime >> 12
      days = (end_datetime - start_datetime).to_i
  end

  # Get First At Time - Time when the Notification first fires off
  def get_first_time(start_time, frequency)
    case frequency
      when :every_minute
        (start_time.to_datetime + (1/1440.0)).to_time # 1 minute
      when :hourly
        (start_time.to_datetime + (1/24.0)).to_time # 1 hour
      when :daily
        (start_time.to_datetime + 1.0).to_time # 1 day
      when :weekly
        (start_time.to_datetime + 7.0).to_time # 1 week
      when :monthly
        (start_time.to_datetime + get_days_to_next_month(start_time).to_f).to_time # 1 month
      when :annualy
        (start_time.to_datetime + get_days_to_next_year(start_time).to_f).to_time # 1 year
    end
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

  # Cancel notification service
  def cancel_notification_service
    @scheduler.shutdown # Kills the notification service
  end
end