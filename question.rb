# Purpose: To Ask Questions and validate the Answers
module SmartGoals
    class Question
        # Ask for a name
        def ask_for_name(question)
            name = CLI.ask(question)  do |q|
                # Check if the friend's name is empty
                q.validate = Helpers.not_empty?

                # Friend name is empty
                q.responses[:not_valid] = "\The name cannot be empty. Please enter a valid name."
            end
        end

        # Ask for an email address
        def ask_for_email(question)
            email = CLI.ask(question) do |q|
            # Check if the friend's email is empty
            q.validate = Helpers.valid_email?

            # Email is not valid
            q.responses[:not_valid] = "\nInvalid email entered. Please enter a valid email. (e.g. someone@example.com)"
            end
        end

        # Ask for a description
        def ask_for_description(question)
            description = CLI.ask(question) do |q|
                # Check if the description is empty
                q.validate = Helpers.not_empty?

                # Description is empty
                q.responses[:not_valid] = "\nYour description cannot be empty. Please enter a valid description."
            end
        end

        # Ask for a target date
        def ask_for_target_date(question)
            target_date = CLI.ask(question) do |q|
            # Validate date
            q.validate = Helpers.valid_date?

            # Date should be a future date
            q.responses[:not_valid] = "The date has to be later than today. Please enter a date in the future."

            # Date should be in dd-mm-yyyy format
            q.responses[:invalid_type] = "Please enter a valid date in dd-mn-yyyy format."
            end
            # Parse the date in dd-mm-yyyy
            target_date = Date.strptime(target_date, "%d-%m-%Y")
        end

    end
end