#
# Be sure to run `pod lib lint APNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APNetwork'
  s.version          = '0.1.0'
  s.summary          = 'I am a network.'

  s.description      = <<-DESC
APNetwork is base on YTKNetwork and AFNetworking.
                       DESC

  s.homepage         = 'http://coderepo.aipai.com:39399/jasxio/APNetwork'
  s.license          = "MIT"
  s.author           = { '673697831' => '673697831@qq.com' }
  s.source           = { :git => 'git@coderepo.aipai.com:jasxio/APNetwork.git', :branch => "dev", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files  = "Classes/*.{h,m}"
  
  s.requires_arc = true
  s.dependency 'YTKNetwork', '~> 1.3.0'
  s.dependency 'SDWebImage', '~> 3.7.1'

end
