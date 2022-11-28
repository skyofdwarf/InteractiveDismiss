#
# Be sure to run `pod lib lint InteractiveDismiss.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InteractiveDismiss'
  s.version          = '0.5.0'
  s.summary          = 'UIPresentationController subclass for interactive modal dismiss'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  InteractiveDismiss is a subclass of `UIPresentationController` for interactive modal dismiss.
  It supports nested scroll views like UIScrollView, UITableView, and UICollectionView.
                       DESC

  s.homepage         = 'https://github.com/skyofdwarf/InteractiveDismiss'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'skyofdwarf' => 'skyofdwarf@gmail.com' }
  s.source           = { :git => 'https://github.com/skyofdwarf/InteractiveDismiss.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'InteractiveDismiss/Classes/**/*'
  
  # s.resource_bundles = {
  #   'InteractiveDismiss' => ['InteractiveDismiss/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
