module Fastlane
  module Actions
    module SharedValues
    end

    class UpdateConfigFileAction < Action
      def self.run(params)
        require 'json'

        chosenWorkspace = params[:workspace]

        configJSON = JSON.load(File.read("#{ENV['CONFIGURATION_BASE_PATH']}#{chosenWorkspace}/#{ENV["CHOSEN_CONFIG"]}-Config.json"))

        configJSON["app"]["api"]["apiUrl"] = "#{ENV['ENVIRONMENT_URL']}"
        apiKey = ENV["#{chosenWorkspace}_API_KEY"]
        configJSON["app"]["api"]["apiKey"] = "#{apiKey}"

        appId = ENV["#{chosenWorkspace}_PARSE_APP_ID"]
        configJSON["app"]["parse"]["applicationId"] = "#{appId}"
        clientKey = ENV["#{chosenWorkspace}_PARSE_CLIENT_KEY"]
        configJSON["app"]["parse"]["clientKey"] = "#{clientKey}"

        File.open("#{ENV['CONFIGURATION_BASE_PATH']}#{chosenWorkspace}/custom-files/Config/#{ENV["CHOSEN_CONFIG"]}-Config.json","w") do |f|
           f.write(JSON.pretty_generate(configJSON))
         end

       end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Changes the apiUrl, apiKey and parse values in the config file to the current environment values for the given workspace"
      end

      def self.details
        "Changes the apiUrl, apiKey and parse values in the config file to the current environment values for the given workspace"
      end

      def self.available_options
        # Define all options your action supports.
        
        [
          FastlaneCore::ConfigItem.new(key: :workspace,
                                       env_name: "WORKSPACE", # The name of the environment variable
                                       description: "Which workspace to change the environment for", # a short description of this parameter
                                       is_string: true),
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
