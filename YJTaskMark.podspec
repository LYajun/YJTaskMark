#
# Be sure to run `pod lib lint YJTaskMark.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YJTaskMark'
  s.version          = '2.0.7'
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
  s.resources = 'YJTaskMark/Classes/SingSound.bundle'

   s.source_files = 'YJTaskMark/Classes/Util/**/*'
    s.dependency 'YJExtensions'
    s.dependency 'YJNetManager'
    s.dependency 'AFNetworking','3.2.1'
    s.dependency 'LGAlertHUD'
    s.dependency 'MJExtension'
    # util.dependency 'AFNetworking','3.2.1'

     s.vendored_libraries = 'YJTaskMark/Classes/Lib/*.a'
      s.vendored_frameworks =  'YJTaskMark/Classes/Lib/*.framework'
 # s.frameworks  = 'Foundation'
      s.libraries   = 'z.1.1.3','z.1','z','c++'
      s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }



end
