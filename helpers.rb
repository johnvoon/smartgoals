require 'pry'

module SmartGoals
  module Helpers
    extend self

    # Validate if input is not empty
    def not_empty?
      proc do |q|
        !q.empty?
      end
    end

    # Validate e-mail address
    def valid_email?
      proc do |q|
        q =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      end
    end

    # Validate date format
    def valid_date?
      proc do |q|
        Time.strptime(q, '%d-%m-%Y') >= Time.now
      end
    end

    # Calculate task target date based on creation date and frequency
    def calculate_task_target_date(creation_date, frequency)
      creation_date + convert_frequency_to_seconds(frequency)
    end

    # Convert frequency symbol to seconds
    def convert_frequency_to_seconds(frequency)
      case frequency
        when :every_minute then 60
        when :hourly then (60 * 60)
        when :weekly then (60 * 60 * 24 * 7)
        when :monthly then (60 * 60 * 24 * 28)
        when :yearly then (60 * 60 * 24 * 365)
      end
    end
  end
end
