Pod::Spec.new do |s|
  s.name         = "VCRouter"
  s.version      = "0.0.1"
  s.summary      = "VCRouter is UINavigationController's manager."
  s.homepage     = "https://github.com/hirohisa/VCRouter"
  s.license      =  {
                      :type => 'MIT',
                      :file => 'LICENSE'
                    }
  s.author       =  {
                      "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com"
                    }
  s.platform     = :ios
  s.source       =  {
                      :git => "https://github.com/hirohisa/VCRouter.git",
                      :tag => "#{s.version}"
                    }
  s.source_files = 'VCRouter/*.{h,m}'
  s.requires_arc = true
end
