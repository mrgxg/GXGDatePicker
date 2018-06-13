Pod::Spec.new do |s|
  s.name             = 'GXGDatePicker'
  s.version          = '0.1.2'
  s.summary          = 'A simple DatePicker'

  s.description      = <<-DESC
     一款简洁、简单的日期选择器， 相比系统自带的UIDatePicker，可以屏蔽掉时间返回以外的不显示，可以循环显示
                       DESC

  s.homepage         = 'https://github.com/mrgxg/GXGDatePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrgxg' => 'gxg0619@163.com' }
  s.source           = { :git => 'https://github.com/mrgxg/GXGDatePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'GXGDatePicker/Classes/**/*'
  

end
