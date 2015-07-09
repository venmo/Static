Pod::Spec.new do |spec|
  spec.name = 'Static'
  spec.version = '0.1.0'
  spec.authors = { 'Venmo' => 'ios@venmo.com' }
  spec.homepage = 'https://github.com/venmo/Static'
  spec.summary = 'Simple static table views for iOS in Swift.'
  spec.source = { :git => 'https://github.com/venmo/Static.git', :tag => "v#{spec.version}" }
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.frameworks = 'Foundation', 'UIKit'
  spec.source_files = 'Static/*.{h,m,swift}'
end
