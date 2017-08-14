# Purpose: To send an email
module SmartGoals
    class Email
        # Send an email message
        def send_email(email, message)

            # Account Credentials
            email_account = 'yourfriendisfailing@gmail.com'
            email_password = 'UpYourGame'

            # Set mail options
            options = {
                :address              => "smtp.gmail.com",
                :port                 => 587,
                :domain               => 'your.host.name',
                :user_name            => email_account,
                :password             => email_password,
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
                from 'SmartGoals Team'
                subject 'SmartGoals Notifications'
                body message
            end
        end
    end
end