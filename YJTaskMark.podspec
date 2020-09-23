#
# Be sure to run `pod lib lint YJTaskMark.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YJTaskMark'
  s.version          = '2.0.1'
  s.summary          = '基于先声的语音评测工具'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LYajun/YJTaskMark'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LYajun' => 'liuyajun1999@icloud.com' }
  s.source           = { :git => 'https://github.com/LYajun/YJTaskMark.git', :tag => s.version.to_s }


  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'YJTaskMark/Classes/*.{h,m}'

  s.dependency 'YJExtensions'
  s.dependency 'AFNetworking','3.2.1'
  s.dependency 'YJNetManager'
  s.dependency 'LGAlertHUD'
  s.dependency 'MJExtension'
  s.dependency 'SingSoundSDK'
end
