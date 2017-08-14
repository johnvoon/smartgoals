# Purpose: To send a popup message
module SmartGoals
    class Popup
        # Send a popup message
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
    end
end