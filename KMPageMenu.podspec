#
# Be sure to run `pod lib lint KMPageMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMPageMenu'
  s.version          = '0.0.2'
  s.summary          = '分页菜单 滑动切换页面 在很多APP中都可以看到极其类似的界面'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
        分页菜单 滑动切换页面 在很多APP中都可以看到极其类似的界面
        支持pod
                       DESC
                       
  s.swift_version    = '4.0'
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.homepage         = 'https://github.com/hkm5558/KMPageMenu'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hkm5558' => 'szhuangkm@163.com' }
  s.source           = { :git => 'https://github.com/hkm5558/KMPageMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.source_files = 'KMPageMenu/Classes/**/*.*'
  
  # s.resource_bundles = {
  #   'KMPageMenu' => ['KMPageMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.framework  = "UIKit"
  # s.dependency 'AFNetworking', '~> 2.3'
end
