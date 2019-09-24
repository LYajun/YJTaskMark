#
# Be sure to run `pod lib lint YJTaskMark.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YJTaskMark'
  s.version          = '1.1.1'
  s.summary          = '基于声通的语音评测工具'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LYajun/YJTaskMark'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LYajun' => 'liuyajun1999@icloud.com' }
  s.source           = { :git => 'https://github.com/LYajun/YJTaskMark.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.resources = 'YJTaskMark/Classes/YJTaskMark.bundle'
  
  s.subspec 'kuyou' do |kouyu|
    kouyu.source_files = 'YJTaskMark/Classes/kouyu/**/*'
    kouyu.vendored_libraries = 'YJTaskMark/Classes/Lib/*.a'
    kouyu.frameworks  = 'Accelerate','Foundation','CoreGraphics','Security','SystemConfiguration','CFNetwork','AudioToolbox'
    kouyu.libraries   = 'z.1'
  end

 s.subspec 'Util' do |util|
    util.source_files = 'YJTaskMark/Classes/Util/**/*'
    util.dependency 'YJTaskMark/kuyou'
    util.dependency 'YJExtensions'
    util.dependency 'YJNetManager'
    util.dependency 'LGAlertHUD'
 end
  
end
