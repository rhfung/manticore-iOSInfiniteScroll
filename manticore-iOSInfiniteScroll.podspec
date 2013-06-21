Pod::Spec.new do |s|
  s.name         = "manticore-iOSInfiniteScroll"
  s.version      = "0.0.8"
  s.summary      = "manticore-iOSInfiniteScroll provides infinite scrolling for UITableView and supports TastyPie pagnination coupled with RestKit."
  s.description  = <<-DESC
          Manticore-iOSInfiniteScroll provides infinite scrolling for UITableView and supports TastyPie pagnination coupled with RestKit.
          DESC
  s.homepage     = "https://github.com/rhfung/manticore-iOSInfiniteScroll"
  s.license      = 'MIT'
  s.author       = { "Richard Fung" => "richard@yetihq.com" }
  s.source       = { :git => "https://github.com/rhfung/manticore-iOSInfiniteScroll.git", :tag => "0.0.8" }
  s.platform     = :ios
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.dependency 'RestKit', '~> 0.20'
  s.dependency 'AFNetworking-TastyPie', '~> 0.0.2'
  s.dependency 'SVPullToRefresh', '~> 0.4.1'
  s.dependency 'Manticore-iOSViewFactory', '~> 0.0.8'
end
