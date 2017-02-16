

Pod::Spec.new do |s|
s.name         = "YQTools"
s.version      = "0.2.0"
s.ios.deployment_target = '8.0'
s.summary      = "some utilities"
s.homepage     = "https://github.com/weixinbing/YQTools"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author             = { "weixb" => "183292352@qq.com" }
s.source       = { :git => "https://github.com/weixinbing/YQTools.git", :tag => s.version }
s.requires_arc = true


s.source_files = 'YQTools/*'

s.subspec 'Macro' do |ss|
ss.source_files = 'YQTools/Macro/*'
end

s.subspec 'Public' do |ss|
ss.source_files = 'YQTools/Public/*'
end

s.subspec 'Category' do |ss|
ss.source_files = 'YQTools/Category/*'
end

s.subspec 'Notification' do |ss|
ss.source_files = 'YQTools/Notification/*'
end

end
