######################### SETUP ##########################

WORKSPACES = ["WORKSPACE_BASE_PATH", "workspaceB", "workspaceC"]
PROJECT_NAMES = {"WORKSPACE_BASE_PATH" => "friendly nameA", "workspaceB" => "friendly nameB", "workspaceC" => "friendly nameC"}
ENVIRONMENTS = ["DevStaging", "Staging", "Production"] 
CURRENT_DEVICES = ["iPhone 7", "iPhone 6s", "iPhone 6s Plus", "iPhone 6", "iPhone 6 Plus", "iPhone 5", "iPhone 4s", "iPad Retina", ]
CURRENT_OS = ["9.2", "9.3", "10.0"] #7.0 8.4
CONFIGURATIONS = ["Debug", "Release"]

# This is the minimum version number required.
# Update this, if you use features of a newer version
fastlane_version "1.50.0"

######################### LANES #########################

default_platform :ios

platform :ios do

  before_all do
  
  opt_out_usage #opt out of usage data
  update_fastlane
  sh "gem cleanup" #clean gems because it complains about old fastlane stuff uninstalled
  
  #ensure_git_status_clean #makes sure there are no uncommitted changes

  commit = last_git_commit
  ENV['CURRENT_GIT_COMMIT_MESSAGE'] = commit[:message]
  ENV['CURRENT_GIT_COMMIT_AUTHOR'] = commit[:author]

  clear_derived_data

  end
  
######################### PUBLIC LANES ##########################

  desc "Runs tests"
  desc "Will prompt for workspace, device and OS"
  desc "Example: fastlane test"
  desc "CI Command: fastlane test workspace:'workspace_name' device:'iPhone 6s' OS:'9.1'"  
  lane :test do |options|
  
    #Prompt for which workspace
    
    chosenWorkspace = options[:workspace] ? options[:workspace] : prompt_with_choices(choicesArray: WORKSPACES, subjectString: "workspace")
    chosenWorkspace.upcase!
    ENV["CHOSEN_WORKSPACE"] = chosenWorkspace

    #Prompt for which device to test
    
    chosenDevice = options[:device] ? options[:device] : prompt_with_choices(choicesArray: CURRENT_DEVICES, subjectString: "device")

    #Prompt for OS
    
    chosenOS = options[:OS] ? options[:OS] : prompt_with_choices(choicesArray: CURRENT_OS, subjectString: "OS")
    
    chosenDevice = "#{chosenDevice} #{chosenOS}"


    ENV["CHOSEN_CONFIG"] = "#{chosenWorkspace}"
    ENV["CHOSEN_SCHEME"] = "#{PROJECT_NAMES[chosenWorkspace]}"

    # update_config_file(workspace: chosenWorkspace) if ENV['ENVIRONMENT_NAME']

    say "Testing on a #{chosenDevice} for #{chosenWorkspace} #{ENV['ENVIRONMENT_NAME']}"
    scan(
      scheme: ENV["CHOSEN_SCHEME"], 
      workspace: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}/#{chosenWorkspace}.xcworkspace",
      device: chosenDevice ? chosenDevice : ENV["DEFAULT_DEVICE"], 
    )
    end

  desc "Takes screenshots for all devices and locales"
  desc "Will prompt for workspace"
  desc "Example: fastlane snap"
  desc "CI Command: fastlane snap workspace:'WorkspaceA'"
  lane :snap do |options|
  
    #Prompt for which workspace
    
    chosenWorkspace = options[:workspace] ? options[:workspace] : prompt_with_choices(choicesArray: WORKSPACES, subjectString: "workspaces")
    chosenWorkspace.upcase!
    ENV["CHOSEN_WORKSPACE"] = chosenWorkspace

    ENV["CHOSEN_CONFIG"] = "#{chosenWorkspace}"
    ENV["CHOSEN_SCHEME"] = "#{PROJECT_NAMES[chosenWorkspace]}"

    # update_config_file(workspace: chosenWorkspace) if ENV['ENVIRONMENT_NAME']

    say "Running snapshot for #{chosenWorkspace} #{ENV['ENVIRONMENT_NAME']}"

    snapshot(
    scheme: ENV["CHOSEN_SCHEME"],
    workspace: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}/#{chosenWorkspace}.xcworkspace",
    )
  end

  desc "Builds the App"
  desc "Example: fastlane build workspace:'WorkspaceA' environment:'DevStaging'"
  lane :build do |options|
  
    #Prompt for which workspace
    
    chosenWorkspace = options[:workspace] ? options[:workspace] : prompt_with_choices(choicesArray: WORKSPACES, subjectString: "workspace")
    chosenWorkspace.upcase!
    ENV["CHOSEN_WORKSPACE"] = chosenWorkspace

    chosenEnviroment = options[:environment] ? options[:environment] : prompt_with_choices(choicesArray: ENVIRONMENTS, subjectString: "environment")


    chosenConfiguration = options[:configuration] ? options[:configuration] : prompt_with_choices(choicesArray: CONFIGURATIONS, subjectString: "configuration")
    ENV["BUILD_CONFIGURATION"] = chosenConfiguration

    # ENV["CHOSEN_CONFIG"] = "#{chosenWorkspace}"
    ENV["CHOSEN_SCHEME"] = "#{PROJECT_NAMES[chosenWorkspace]}-#{chosenEnviroment}"

    ENV['APP_ICONS_PATH'] = "#{PROJECT_NAMES[chosenWorkspace]}/Images.xcassets/AppIcon.appiconset"
    # if !is_ci
    #   say "Updating config file for #{ENV["CHOSEN_CONFIG"]}"
    #   update_config_file(workspace: chosenWorkspace) if ENV['ENVIRONMENT_NAME']
    # end

    cert(
       output_path: ENV["CERTIFICATE_DIR_PATH"]
    )
    sigh(
    #  force: true, #makes sure profile is always up to date
      output_path: ENV["PROFILE_DIR_PATH"],
      app_identifier: "<<app id>>.#{chosenWorkspace}".downcase,
    )
  
  
    ENV["PROFILE_UDID"] = lane_context[SharedValues::SIGH_UDID] # use the UDID of the newly created provisioning profile

    if !is_ci

      increment_build_number(
        xcodeproj: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}/#{PROJECT_NAMES[chosenWorkspace]}.xcodeproj",
        build_number: number_of_commits
      )  
      
  #    increment_version_number(
  #      xcodeproj: "./#{chosenWorkspace}/#{PROJECT_NAMES[chosenWorkspace]}.xcodeproj",  
  #      bump_type: "patch" # choices are patch, minor, major
  #    )    
      say "Building #{ENV["CHOSEN_SCHEME"]}"

      overlay_app_icon(
        overlay_type: "text", 
        text_overlay_font: "Techno", 
        text_background_color: "#FF0000" , 
        text_overlay: chosenEnviroment, 
        appiconset_path: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}#{ENV['APP_ICONS_PATH']}"
      ) 
    end

    gym(
      scheme: ENV["CHOSEN_SCHEME"], 
      configuration: ENV["BUILD_CONFIGURATION"], 
      clean: true, 
      include_bitcode: false,
      workspace: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}/#{chosenWorkspace}.xcworkspace",
      output_directory: ENV["BUILD_OUTPUT_PATH"],
      archive_path: ENV["BUILD_OUTPUT_PATH"],
      output_name: "#{PROJECT_NAMES[chosenWorkspace]}.ipa", #TODO maybe change
      use_legacy_build_api: true #added this to make archive work, see https://github.com/fastlane/gym/issues/90 and https://openradar.appspot.com/radar?id=4952000420642816
    )

  # commit_version_bump(
  #   message: 'Version Bump by fastlane',
  #   xcodeproj: project_file,
  #   force: true
  # )
  

  #push_to_git_remote

    if !is_ci
      fabric(
        workspace: "#{chosenWorkspace}"
      )
    end


    reset_git_repo(
      force: true,
      skip_clean: false,# If you want 'git clean' to be skipped, thus NOT deleting untracked files like '.env'. Optional, defaults to false.
      # files: [
      # "./#{chosenWorkspace}#{ENV['APP_ICONS_PATH']}",#reset app icons
      # "./#{chosenWorkspace}#{ENV['CONFIG_FILE_PATH']}" #reset config file
      # ]
    ) 

    
  end
        
  lane :framework do |options|
  
    #Prompt for which workspace
    
    chosenWorkspace = options[:workspace] ? options[:workspace] : prompt_with_choices(choicesArray: WORKSPACES, subjectString: "workspace")
    chosenWorkspace.upcase!

    # update_config_file(workspace: chosenWorkspace) if ENV['ENVIRONMENT_NAME']

    cert(
       output_path: ENV["CERTIFICATE_DIR_PATH"]
    )
    sigh(
    #  force: true, #makes sure profile is always up to date
      output_path: ENV["PROFILE_DIR_PATH"],
      app_identifier: "com.<<app id>>.#{chosenWorkspace}".downcase,
    )
  
    ENV["PROFILE_UDID"] = lane_context[SharedValues::SIGH_UDID] # use the UDID of the newly created provisioning profile
    
    say "Building Framework for #{chosenWorkspace} #{ENV['ENVIRONMENT_NAME']}"

    xcodebuild(
      scheme: "Framework#{chosenWorkspace}",
      workspace: "#{ENV['WORKSPACE_BASE_PATH']}#{chosenWorkspace}/#{chosenWorkspace}.xcworkspace",
      configuration: "Debug", #has to be Debug for Build Fat Library Script, We only want simulator built
      sdk: "iphonesimulator",
      destination: ENV["BUILD_DESTINATION"]
    )

  end
  
######################### UTIL LANES #########################

  private_lane :fabric do |options|
    chosenWorkspace = options[:workspace] ? options[:workspace] : prompt_with_choices(choicesArray: WORKSPACES, subjectString: "workspace")
    chosenWorkspace.upcase!

#   version = get_version_number(xcodeproj: "./#{chosenWorkspace}/#{PROJECT_NAMES[chosenWorkspace]}.xcodeproj")
#   build = get_build_number(xcodeproj: "./#{chosenWorkspace}/#{PROJECT_NAMES[chosenWorkspace]}.xcodeproj")
    date = Time.new.strftime("%Y.%m.%d %I:%M%p")

    full_commit_hash = sh "git rev-parse HEAD"
    short_commit_hash = full_commit_hash[0..6] #first 7 characters of current commit hash

    crashlytics(
      ipa_path: "#{ENV['BUILD_OUTPUT_PATH']}#{PROJECT_NAMES[chosenWorkspace]}.ipa",
      #TODO: could prompt for release notes here
      notes: "#{ENV["CHOSEN_SCHEME"]} #{date} Commit: #{short_commit_hash}",
      notifications: true,
      groups: [ENV['CRASHLYTICS_GROUP_NAME']]
    )
    
    # upload dsym
    upload_symbols_to_crashlytics

  end

######################### AFTER ALL #########################

  after_all do |lane|
  
    hipchat(
    message: "Fastlane finished #{ENV["CHOSEN_SCHEME"]} #{lane} #{ENV["BUILD_CONFIGURATION"]} on branch '#{ENV['CI_BUILD_REF_NAME']}'. Commit message: #{ENV['CURRENT_GIT_COMMIT_MESSAGE']}\n\n Commit author: #{ ENV['CURRENT_GIT_COMMIT_AUTHOR']}",
    message_format: "html",
    channel: "Autobuild",
    success: true
    )

    if !is_ci
      notification(message: "Fastlane finished #{ENV["CHOSEN_SCHEME"]} #{lane} #{ENV["BUILD_CONFIGURATION"]} on branch '#{ENV['CI_BUILD_REF_NAME']}'. Commit message: #{ENV['CURRENT_GIT_COMMIT_MESSAGE']} Commit author: #{ ENV['CURRENT_GIT_COMMIT_AUTHOR']}") # Mac OS X Notification
    end
    # Make sure our directory is clean, except for changes Fastlane has made
    #clean_build_artifacts


  end

  error do |lane, exception|
  
    hipchat(
    message: "Fastlane failed #{ENV["CHOSEN_SCHEME"]} #{lane} #{ENV["BUILD_CONFIGURATION"]} on branch '#{ENV['CI_BUILD_REF_NAME']}'. Commit message: #{ENV['CURRENT_GIT_COMMIT_MESSAGE']}\n\n Commit author: #{ ENV['CURRENT_GIT_COMMIT_AUTHOR']}",
    message_format: "html",
    channel: "Autobuild",
    success: false
    )
    if !is_ci
     notification(message: "Fastlane failed #{ENV["CHOSEN_SCHEME"]} #{lane} #{ENV["BUILD_CONFIGURATION"]} on branch '#{ENV['CI_BUILD_REF_NAME']}'") # Mac OS X Notification
    end
    # Make sure our directory is clean, except for changes Fastlane has made
    #clean_build_artifacts  
  end
end
