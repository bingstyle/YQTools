

Pod::Spec.new do |s|
s.name         = "YQTools"
s.version      = "0.3.0"
s.ios.deployment_target = '8.0'
s.summary      = "some utilities"
s.homepage     = "https://github.com/weixinbing/YQTools"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author             = { "weixb" => "183292352@qq.com" }
s.source       = { :git => "https://github.com/weixinbing/YQTools.git", :tag => s.version }
s.requires_arc = true

s.source_files = 'YQTools/*'

s.subspec 'Macro' do |ss|
ss.source_files = 'YQTools/Macro/*.{h}'
end

s.subspec 'Utilities' do |ss|
ss.source_files = 'YQTools/Utilities/*.{h,m}'
end

s.subspec 'Category' do |ss|
ss.source_files = 'YQTools/Category/*', 'YQTools/Category/**/*'
end

s.subspec 'Notification' do |ss|
ss.source_files = 'YQTools/Notification/*.{h,m}'
end

end
