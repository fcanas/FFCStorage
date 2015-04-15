Pod::Spec.new do |s|
  s.name         = "FFCStorage"
  s.version      = "0.0.1"
  s.summary      = "Auth and Network handling so you can store models in s RESTful API"

  s.description  = <<-DESC
                   Auth and Network handling so you can store models in s RESTful API.
                   DESC

  s.homepage     = "https://github.com/fcanas/FFCStorage"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  
  s.license      = "MIT"  
  s.author             = { "Fabian Canas" => "fcanas@gmail.com" }
  s.social_media_url   = "http://twitter.com/fcanas"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source       = { :git => "https://github.com/fcanas/FFCStorage.git", :tag => "0.0.1" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source_files  = "FFCStorage", "FFCStorage/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "OHMKit", "~> 0.2.0"
  s.dependency "SafeCast", "~> 1.1.1"
  s.dependency "FXKeychain", "~> 1.5.2"
  s.dependency "Realm", git: 'https://github.com/fcanas/realm-cocoa.git', commit: '2767a1951bd4c554874170e852c2e382fa8e715b'
  
end
