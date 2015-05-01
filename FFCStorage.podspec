Pod::Spec.new do |s|
  s.name         = "FFCStorage"
  s.version      = "0.1.0"
  s.summary      = "Auth and Network handling so you can store models in a RESTful API"
  s.description  = <<-DESC
                   Auth and Network handling so you can store models in a RESTful API.
                   DESC
  s.homepage     = "https://github.com/fcanas/FFCStorage"
  s.license      = "MIT"  
  s.author             = { "Fabian Canas" => "fcanas@gmail.com" }
  s.social_media_url   = "http://twitter.com/fcanas"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/fcanas/FFCStorage.git", :tag => "v0.1.0" }
  s.source_files  = "FFCStorage", "FFCStorage/**/*.{h,m}"
  s.dependency "SafeCast", "~> 1.1.1"
  s.dependency "FXKeychain", "~> 1.5.2"
end
