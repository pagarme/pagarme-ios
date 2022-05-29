Pod::Spec.new do |s|
    s.name         = 'PagarMe'
    s.version      = '2.0.0'
    s.summary      = 'Pagar.me Library for iOS'
    s.homepage     = 'https://github.com/pagarme/pagarme-ios'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.author       = 'Regis Araujo'
    s.platform     = :ios, '11.0'
    s.ios.deployment_target = '11.0'
    s.source       = { :git => 'https://github.com/pagarme/pagarme-ios.git', :tag => s.version }
    s.source_files = 'Sources/PagarMe/Classes/**/*'
    s.framework    = 'Security'
    s.requires_arc = true
    s.dependency 'SwiftLuhn'
end
