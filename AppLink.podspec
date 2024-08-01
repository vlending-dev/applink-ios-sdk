Pod::Spec.new do |s|
  s.name         = 'VlendingAppLink'
  s.module_name  = 'AppLink'
  s.version      = '0.0.1'
  s.summary      = 'Deep link service provided for iOS'
  s.description  = 'Helps create and recognize deep links in apps developed for iOS.'
  s.homepage     = 'https://github.com/vlending-dev/applink-ios-sdk'
  s.license      = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author       = { 'Vlending Co., Ltd.' => 'https://www.vlending.kr' }
  s.source       = { :git => 'https://github.com/vlending-dev/applink-ios-sdk.git',
                     :tag => "#{s.version}" }
  s.platform     = :ios, '13.0'
  s.source_files = 'Framework/*.{swift,h}'
  s.frameworks   = 'UIKit', 'Foundation'
  s.swift_version = '5.10'
  s.resource_bundles = {'VlendingAppLink' => ['Framework/PrivacyInfo.xcprivacy']}
end
