Pod::Spec.new do |s|
  s.name             = "SimpleTimer"
  s.version          = "0.1.0"
  s.summary          = "Simplify work with NSTimer."
  s.homepage         = "https://github.com/alerstov/SimpleTimer"
  s.license          = 'MIT'
  s.author           = { "Alexander Stepanov" => "alerstov@gmail.com" }
  s.source           = { :git => "https://github.com/alerstov/SimpleTimer.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = '*.{h,m}'
end
