# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CareMate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for CareMate
  pod 'Alamofire'
  pod 'Firebase'
 # pod 'Firebase/Auth'
#  pod 'Firebase/Crashlytics'
#  pod 'Firebase/Core'
#  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
#  pod 'Firebase/Storage'
  pod 'SVProgressHUD'
  pod 'RealmSwift'
  pod 'Kingfisher'
  pod 'IQKeyboardManagerSwift'
  pod 'PopupDialog'
  pod 'Reachability'

  
  pod 'MaterialComponents/Tabs'
  pod 'Stuff/Codable'
  pod 'SwiftyJSON'
  pod 'LKAlertController'
  pod 'SCLAlertView' , :git => 'https://github.com/vikmeup/SCLAlertView-Swift'
  pod 'HRRoundAndBorderedView'
  pod 'pop', '~> 1.0'
  pod 'NitroUIColorCategories'
  pod 'MZFormSheetController', '~> 3.1'
  pod 'GiFHUD-Swift'

  pod 'CCMPopup'
  pod 'ObjectMapper'
  pod 'BetterSegmentedControl', '~> 1.0'
  pod 'DZNEmptyDataSet'
  pod 'OhhAuth'
  pod 'OAuthSwift', '~> 1.2.0'
#  pod 'RealmSwift', '~> 10.20.0'


  pod 'CountryPickerView'
  pod 'JNPhoneNumberView'
  pod 'FMDB'
  pod 'FSCalendar', '~> 2.8'
  pod 'DropDown'
  pod 'SwiftyCodeView'
  pod 'MOLH'
  pod 'PinCodeTextField'
  pod 'GoogleMaps'
  pod'ImageSlideshow'
  pod 'GooglePlaces'
  pod 'TPPDF'
#  pod 'JLActivityIndicator', '~> 2.1'
  pod 'CRRefresh', '~> 1.1.3'
  pod 'ZoomVSDKUIToolkitiOS/ZoomVideoSDK'
  pod 'ZoomVSDKUIToolkitiOS/ZoomVideoSDKUIToolkit'
  pod 'ZoomVSDKUIToolkitiOS/CptShare'
  pod 'ZoomVSDKUIToolkitiOS/zoomcml'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
