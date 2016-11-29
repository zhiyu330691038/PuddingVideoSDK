Pod::Spec.new do |s|
s.name             = 'PuddingVideoSDK'
s.version          = '1.0.3'
s.summary          = '北京智能管家视频sdk 静态库.'

s.platform = :ios, "9.0"

s.description      = <<-DESC
TODO: 北京智能管家视频sdk.
DESC
s.requires_arc    = true

s.homepage         = 'git@github.com:RooboMobile/PuddingVideoSDK.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'zhikuiyu' => 'zky_416@sina.com' }
s.source           = { :git => 'https://github.com/RooboMobile/PuddingVideoSDK.git', :tag => s.version.to_s }

s.ios.deployment_target = '7.0'

s.source_files = 'PuddingVideoSDK/Classes/**/*'

s.vendored_libraries = 'PuddingVideoSDK/Assets/*.a'
s.libraries = 'icucore','bz2','z','c++','iconv'
s.frameworks = 'UIKit', 'MapKit','AVFoundation','WebKit','AudioToolBox','MediaPlayer','OpenGLES','GLKit','SystemConfiguration','CoreMedia','CoreVideo','MobileCoreServices','VideoToolbox'
end

