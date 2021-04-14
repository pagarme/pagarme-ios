Pod::Spec.new do |s|
  s.name         = 'PagarMe'
  s.version      = '1.1.1'
  s.summary      = 'Pagar.me Library for iOS'
  s.homepage     = 'https://github.com/pagarme/pagarme-ios'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = 'Luciano Nascimento'
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/pagarme/pagarme-ios.git', :tag => s.version }
  s.source_files = 'PagarMe/**/*.{h,m}'
  s.framework    = 'Security'
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'ObjectiveLuhn', '~> 1.0'
end
