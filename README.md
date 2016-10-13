fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs tests

Will prompt for workspace, device and OS

Example: fastlane test

CI Command: fastlane test workspace:'WorkspaceA' device:'iPhone 6s' OS:'9.1'
### ios snap
```
fastlane ios snap
```
Takes screenshots for all devices and locales

Will prompt for workspace

Example: fastlane snap

CI Command: fastlane snap workspace:'WorkspaceA'
### ios build
```
fastlane ios build
```
Builds the App

Example: fastlane build workspace:'WorkspaceA' environment:'DevStaging'
### ios framework
```
fastlane ios framework
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
