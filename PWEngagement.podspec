Pod::Spec.new do |spec|
  spec.name = 'PWEngagement'
  spec.version = '3.11.0-beta-01'
  spec.license = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware Inc. All rights reserved.' }
  spec.summary = "Phunware's Mobile Engagement SDK for use with its Multiscreen-as-a-Service platform"
  spec.homepage = 'https://github.com/phunware/maas-engagement-ios-sdk/'
  spec.author = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url = 'https://twitter.com/phunware'
  
  spec.platform = :ios, '13.0'
  spec.source = { :git => "https://github.com/phunware/maas-engagement-ios-sdk.git", :tag => "v#{spec.version}" }
  spec.documentation_url = 'https://phunware.github.io/maas-engagement-ios-sdk/'

  spec.default_subspecs =
    'Core',
    'DeviceIdentity'

  spec.subspec 'Core' do |subspec|
    subspec.dependency 'PWCore', '~> 3.12.0-beta-03'
    subspec.dependency 'FMDB/SQLCipher', '~> 2.7.0'

    subspec.vendored_frameworks = 'Frameworks/PWEngagement.xcframework'
    
    subspec.frameworks = 'CoreLocation'

    subspec.libraries =
      'sqlite3',
      'z'
  end
  
  spec.subspec 'DeviceIdentity' do |subspec|
    subspec.dependency 'PWEngagement/Core'
    subspec.dependency 'PWCore/DeviceIdentity', '~> 3.12.0-beta-03'
  end
  
  spec.subspec 'LimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWEngagement/Core'
  end

  spec.subspec 'MistBeaconProviderCore' do |subspec|
    subspec.dependency 'PWEngagement/Core'
    subspec.dependency 'MistSDKDR', '1.5.280'

    subspec.vendored_frameworks = 'Frameworks/MistBeaconProvider.xcframework'
    
    subspec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    subspec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  end

  spec.subspec 'MistBeaconProvider' do |subspec|
    subspec.dependency 'PWEngagement/MistBeaconProviderCore'
    subspec.dependency 'PWEngagement/DeviceIdentity'
  end
  
  spec.subspec 'MistBeaconProviderWithLimitedDeviceIdentity' do |subspec|
    subspec.dependency 'PWEngagement/MistBeaconProviderCore'
  end
end
