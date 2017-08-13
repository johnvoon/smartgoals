module SmartGoals
    class Email
        # Send an email message
        def send_email(email, message)
            # Set mail options
            options = {
                :address              => "smtp.gmail.com",
                :port                 => 587,
                :domain               => 'your.host.name',
                :user_name            => 'tellyourbuddytouptheirgame@gmail.com',
                :password             => 'UpYourGame',
                :authentication       => 'plain',
                :enable_starttls_auto => true
            }

            # Set mail options to Mail object
            Mail.defaults do
                delivery_method :smtp, options
            end
            
            # Send the email message
            Mail.deliver do
                to email
                from 'tellyourbuddytouptheirgame@gmail.com'
                subject 'SmartGoals Notifications'
                body message
            end
        end
    end
end