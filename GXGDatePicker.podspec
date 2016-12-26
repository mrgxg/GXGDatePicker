Pod::Spec.new do |s|
  s.name             = 'GXGDatePicker'
  s.version          = '0.1.0'
  s.summary          = 'A simple DatePicker'

  s.description      = <<-DESC
        简单的日期选择器
                       DESC

  s.homepage         = 'https://github.com/mrgxg/GXGDatePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrgxg' => 'gxg0619@163.com' }
  s.source           = { :git => 'https://github.com/mrgxg/GXGDatePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'GXGDatePicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GXGDatePicker' => ['GXGDatePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

end
