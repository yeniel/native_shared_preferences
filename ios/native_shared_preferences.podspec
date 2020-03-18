#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_shared_preferences.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_shared_preferences'
  s.version          = '1.0.0'
  s.summary          = 'Shared preferences for migration of native app'
  s.description      = <<-DESC
Shared preferences for migration of native app
                       DESC
  s.homepage         = 'https://github.com/yeniel/native_shared_preferences'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'y3ni3l@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
