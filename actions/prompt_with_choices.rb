module Fastlane
  module Actions
    module SharedValues
     # PROMPT_WITH_CHOICES_CUSTOM_VALUE = :PROMPT_WITH_CHOICES_CUSTOM_VALUE
    end

    class PromptWithChoicesAction < Action
      def self.run(params)

    possibleChoices = params[:choicesArray]
    #Setup the prompt with the choices
    promptText = "\nChoose the #{params[:subjectString]}"
    count = 1
    possibleChoices.each do |i|
        promptText = "#{promptText}\n#{count}. #{i}"
        count = count + 1
    end
    
    begin
        choice = Fastlane::Actions::PromptAction.run(text:promptText)
        intChoice = choice.to_i - 1

        unless possibleChoices.any?{ |s| s.casecmp(choice)==0 || (possibleChoices.count > intChoice && intChoice >= 0)} #case insensitive check for their string, also checks if its within the indexes of the choices
            puts "That is not one of the #{params[:subjectString]}"
            raise "Wrong input"
        end
    rescue 
        retry #starts at begin
    end

    if possibleChoices.count > intChoice && intChoice >= 0 #checks if the choice is within the indexes of the choices
      return possibleChoices[intChoice]
    end

    return choice

    end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Prompts the user with the choices provided, checks for input errors"
      end

      def self.details
        "Prompts the user with the choices provided, checks for input errors. Needs an array of choice strings and the subject string"
      end

      def self.available_options
        # Define all options your action supports.
        
        [
          FastlaneCore::ConfigItem.new(key: :choicesArray,
                                       env_name: "PROMPT_WITH_CHOICES_CHOICES", # The name of the environment variable
                                       description: "Choices to display to the user for PromptWithChoicesAction", # a short description of this parameter
                                       is_string: false,
                                       verify_block: proc do |value|
                                          raise "No choices for PromptWithChoicesAction given, pass using `choicesArray: 'array_of_choices'`".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :subjectString,
                                       env_name: "PROMPT_WITH_CHOICES_SUBJECT",
                                       description: "The subject of the choices given",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
      
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["msouthin"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
