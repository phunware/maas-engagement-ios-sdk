Pod::Spec.new do |s|
  s.name         = "PWEngagement"
  s.version      = "3.10.0"
  s.summary      = "Phunware's Mobile Engagement SDK for use with its Multiscreen-as-a-Service platform"
  s.homepage     = "http://phunware.github.io/maas-engagement-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '10.0'
  s.source       = { :git => "https://github.com/phunware/maas-engagement-ios-sdk.git", :tag => "v#{s.version}" }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Frameworks/PWEngagement.xcframework'

  s.ios.dependency 'FMDB'
        
  s.default_subspec = 'all-frameworks'

  s.subspec 'all-frameworks' do |sub|
    sub.dependency 'PWCore', '~> 3.11.0'
    sub.dependency 'PWCore/DeviceIdentity', '~> 3.11.0'
  end
  
  s.subspec 'LimitedDeviceIdentity' do |sub|
    sub.ios.vendored_frameworks = 'Frameworks/PWEngagement.xcframework'
    sub.dependency 'PWCore', '~> 3.10.0'
  end

  s.subspec 'MistBeaconProvider' do |sub|
    sub.ios.vendored_frameworks = 'Frameworks/MistBeaconProvider.xcframework'
    sub.dependency 'MistSDKDR', '1.5.272'
    sub.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
    sub.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  end
                
  s.library = 'sqlite3', 'z'
  s.ios.frameworks = 'CoreLocation'
  s.requires_arc  = true

end
