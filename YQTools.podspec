

Pod::Spec.new do |s|
s.name         = "YQTools"
s.version      = "0.1.2"
s.ios.deployment_target = '8.0'
s.summary      = "some utilities"
s.homepage     = "https://github.com/weixinbing/YQTools"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author             = { "weixb" => "183292352@qq.com" }
s.source       = { :git => "https://github.com/weixinbing/YQTools.git", :tag => s.version }
s.requires_arc = true

s.dependency "YTKNetwork", "~> 2.0.3"
s.dependency 'Bugly', '~> 2.4.2'
s.dependency "AFNetworking", "~> 3.1.0"
s.dependency 'FMDB', '~> 2.6.2'
s.dependency 'SDWebImage', '~> 4.0.0'
s.dependency 'Masonry', '~> 1.0.0'
s.dependency 'MJRefresh', '~> 3.1.12'
s.dependency 'MJExtension', '~> 3.0.13'
s.dependency 'ReactiveCocoa','2.5'
s.dependency 'SVProgressHUD', '~> 2.1.2'

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
