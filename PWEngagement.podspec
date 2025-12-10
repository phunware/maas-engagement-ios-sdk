Pod::Spec.new do |spec|
  spec.name = 'PWEngagement'
  spec.version = '3.14.4'
  spec.license = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }
  spec.summary = "Phunware's Mobile Engagement SDK for use with its Multiscreen-as-a-Service platform"
  spec.homepage = 'https://github.com/phunware/maas-engagement-ios-sdk/'
  spec.author = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url = 'https://twitter.com/phunware'
  
  spec.platform = :ios, '15.5'
  spec.source = { :git => 'https://github.com/phunware/maas-engagement-ios-sdk.git', :tag => "#{spec.version}" }
  spec.documentation_url = 'https://phunware.github.io/maas-engagement-ios-sdk/'
  spec.cocoapods_version = '>= 1.15.2'

  spec.default_subspecs =
    'Core',
    'DeviceIdentity'

  spec.subspec 'Core' do |subspec|
    subspec.dependency 'PWCore', '~> 3.13.0'
    subspec.dependency 'FMDB/SQLCipher', '~> 2.7.12'

    subspec.vendored_frameworks = 'Frameworks/PWEngagement.xcframework'
    
    subspec.frameworks = 'CoreLocation'

    subspec.libraries =
      'sqlite3',
      'z'
  end
  
  spec.subspec 'DeviceIdentity' do |subspec|
    subspec.dependency 'PWEngagement/Core'
    subspec.dependency 'PWCore/DeviceIdentity', '~> 3.13.0'
  end
  
  spec.subspec 'LimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWEngagement/Core'
  end
end
