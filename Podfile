# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Job Finder' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Job Finder
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SDWebImage'
    pod 'GooglePlaces'
    pod 'SVProgressHUD'
    pod 'AlamofireNetworkActivityLogger', '~> 2.0'
    pod 'TOWebViewController'

  target 'Job FinderTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
