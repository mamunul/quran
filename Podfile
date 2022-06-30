# Uncomment the next line to define a global platform for your project

workspace 'QuranAndSunnah.xcworkspace'

target 'QuranAndSunnah' do
  platform :ios, '14.0'
  project 'QuranAndSunnah/QuranAndSunnah.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HTMLTextAttributes
#  pod 'SwiftSoup'
end

target 'IbnKathirParser' do
  platform :macos, '12.0'
  project 'IbnKathirParser/IbnKathirParser.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static
  inhibit_all_warnings!

  # Pods for HTMLTextAttributes
  pod 'SwiftSoup', :inhibit_warnings => true
end

target 'AppstoreAutomation' do
  platform :macos, '12.0'
  project 'AppstoreAutomation/AppstoreAutomation.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  # Pods for HTMLTextAttributes
  pod 'AppStoreConnect-Swift-SDK', :git => 'https://github.com/AvdLee/appstoreconnect-swift-sdk.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['OTHER_CFLAGS'] = "-Wno-deprecated"
      config.build_settings['DEAD_CODE_STRIPPING'] = "YES"
      config.build_settings.delete 'ARCHS'
#      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
#      config.build_settings.delete 'ARCHS'
#      config.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
