#
# Be sure to run `pod lib lint ACBestOfTheRest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ACBestOfTheRest'
  s.version          = '0.2'
  s.summary          = 'With ACBestOfTheRest you can easily reflect JSON responses on UITableView or UICollectionView with no code.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ACBestOfTheRest allows you to set up field names of JSON responses directly in the storyboard file and make everything working just with it. Drop BOTRTableView or BOTRCollectionView on the view of your UIViewController, specify API url path, API manager class, set fields and default values for BOTRLabel and BOTRImageView views and that's it. Really. No code, it's just working. ACBestOfTheRest is very light and agile, e.g. you can use convertors to format values of JSON responses, overridden methods to do extra thing and so on.
                       DESC

  s.homepage         = 'https://github.com/AppCraft-LLC/ACBestOfTheRest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AppCraft LLC' => 'support@appcraft.pro' }
  s.source           = { :git => 'https://github.com/AppCraft-LLC/ACBestOfTheRest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ACBestOfTheRest/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ACBestOfTheRest' => ['ACBestOfTheRest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
end
