Pod::Spec.new do |s|
  s.name             = "ReactiveUIKit"
  s.version          = "1.0.0"
  s.summary          = "Reactive extensions for UIKit framework."
  s.homepage         = "https://github.com/ReactiveKit/ReactiveUIKit"
  s.license          = 'MIT'
  s.author           = { "Srdan Rasic" => "srdan.rasic@gmail.com" }
  s.source           = { :git => "https://github.com/ReactiveKit/ReactiveUIKit.git", :tag => "v1.0.0" }

  s.ios.deployment_target       = '8.0'
  s.tvos.deployment_target      = '9.0'

  s.source_files      = 'ReactiveUIKit/**/*.{h,swift}'
  s.requires_arc      = true

  s.dependency 'ReactiveKit'
  s.dependency 'ReactiveFoundation'
end
