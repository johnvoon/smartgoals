require 'pry'

module SmartGoals
  module Helpers
    extend self

    def valid_email?
      proc { |q| q =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
    end

    def valid_date?
      proc do |q|
        Time.strptime(q, '%d-%m-%Y') >= Time.now
      end
    end

    def calculate_task_target_date(creation_date, frequency)
      creation_date + convert_frequency_to_seconds(frequency)
    end

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
