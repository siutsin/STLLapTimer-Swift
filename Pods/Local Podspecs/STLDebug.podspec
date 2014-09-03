#
# Be sure to run `pod lib lint STLDebug.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "STLDebug"
  s.version          = "0.0.1"
  s.summary          = "Handy debug utility for UIView and NSLog"
  s.description      = <<-DESC
                       Handy debug utility for UIView and NSLog

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/siutsin/STLDebug"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Simon Li" => "simon824@gmail.com" }
  s.source           = { :git => "https://github.com/siutsin/STLDebug.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/simon__li'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'STLDebug' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
