Pod::Spec.new do |s|

  s.name         = "GNInAppPurchaseManager"
  s.version      = "0.0.6"
  s.summary      = "StoreKit wrapper with convinient block functions."

  s.description  = <<-DESC
                   StoreKit wrapper with convinient block functions. Easy transaction and purchase handling.
                   DESC

  s.homepage     = "https://github.com/jakubknejzlik/GNInAppPurchaseManager"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Jakub Knejzlik" => "jakub.knejzlik@gmail.com" }

  s.platform     = :ios

  s.ios.deployment_target = "6.0"
  # s.osx.deployment_target = "10.7"


  s.source       = { :git => "https://github.com/jakubknejzlik/GNInAppPurchaseManager.git", :tag => s.version.to_s }

  s.source_files  = "Lib", "Lib/**/*.{h,m}"

  s.framework  = "StoreKit"

  s.requires_arc = true

  s.dependency "CWLSynthesizeSingleton", '~> 1.0'
  s.dependency "Lockbox", '~> 2.1'

end
