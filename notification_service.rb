class NotificationService
    
    attr_accessor :schedule

    def initialize
        @scheduler = Rufus::Scheduler.new
    end

    def message
        
        # Will run a notification every 3 seconds just as an example
        @scheduler.every '3s' do #.at '2017/08/10 18:50:00' do
            system("echo 'Hello Smart Goals!' | terminal-notifier -sound default")
            #@scheduler.shutdown
        end
        @scheduler.join
    end

    def shutdown
        @scheduler.shutdown
    end
end