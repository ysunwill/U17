# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'U17' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # oc
  pod 'AFNetworking'                  # 网络请求
  pod 'Masonry'                       # UI布局
  pod 'SVProgressHUD'                 # HUD提示框
  pod 'IQKeyboardManager'             # 键盘处理
  pod 'MJRefresh'                     # 列表刷新
  pod 'MJExtension'                   # 数据转模型
  pod 'SDWebImage'                    # 网络图片加载
  pod 'JXCategoryView'                # 分页视图
  pod 'MBProgressHUD'


  # swift
#  pod 'Alamofire', '4.9.1'
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'Moya', '~> 13.0.0'
  pod 'UIAdapter'                     # 屏幕适配
  pod 'FlexLayout'                    # UI布局
  pod 'PinLayout'
  pod 'R.swift'
  pod 'Then'
  pod 'FSPagerView'                   # 轮播图
  pod 'Reusable'
  pod 'CodableWrapper'          
  pod 'EmptyDataSet-Swift'
  pod 'Result'
  
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'  # 最低适配iOS 10.0, 这里设置第三方适配最低版本,避免部分警告出现
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
