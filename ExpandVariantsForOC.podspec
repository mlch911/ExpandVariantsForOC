Pod::Spec.new do |s|

    s.name         = "ExpandVariantsForOC"
    s.version      = "0.0.1"
    s.summary      = "Swift Macro for allowing variable declarations even in class extensions."
  
    s.description  = <<-DESC
    Swift Macro for allowing variable declarations even in class extensions.
                     DESC
  
    s.homepage     = "https://github.com/mlch911/ExpandVariantsForOC"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "mlch911" => "https://github.com/mlch911" }
  
    s.ios.deployment_target = "13.0"
    s.tvos.deployment_target = "13.0"
    s.osx.deployment_target = "10.15"
    s.watchos.deployment_target = "6.0"
  
    s.source       = { :git => "https://github.com/mlch911/ExpandVariantsForOC", :tag => "#{s.version}" }
  
    s.prepare_command = 'swift build -c release && cp -f .build/release/ExpandVariantsForOCPlugin ./Binary'
  
    s.source_files  = "Sources/ExpandVariantsForOC/**/*.{c,h,m,swift}", 'Sources/ExpandVariantsForOC/**/*.{c,h,m,swift}'
    s.swift_versions = "5.9"
  
    s.preserve_paths = ["Binary/ExpandVariantsForOCPlugin"]
    s.pod_target_xcconfig = {
      'OTHER_SWIFT_FLAGS' => [
        '-load-plugin-executable ${PODS_ROOT}/ExpandVariantsForOC/Binary/ExpandVariantsForOCPlugin#ExpandVariantsForOCPlugin'
      ]
    }
    s.user_target_xcconfig = {
      'OTHER_SWIFT_FLAGS' => [
        '-load-plugin-executable ${PODS_ROOT}/ExpandVariantsForOC/Binary/ExpandVariantsForOCPlugin#ExpandVariantsForOCPlugin'
      ]
    }
  
  end
  