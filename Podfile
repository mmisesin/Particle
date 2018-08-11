# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def sharedPods
  pod 'SwiftSoup'
  pod 'SwiftLint'
  pod 'CocoaLumberjack/Swift'
end

target 'Particle' do

  sharedPods

end


target 'AddParticleExtension' do
  
  sharedPods

end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end