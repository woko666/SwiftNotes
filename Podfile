# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

def shared_pods
  	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  	use_frameworks!
    inhibit_all_warnings!

    pod 'CleanroomLogger', :git => 'https://github.com/woko666/CleanroomLogger.git'
    pod 'Realm'
    pod 'RealmSwift'
    pod 'Moya/RxSwift'
    pod 'RxCocoa'
    pod 'Swinject', '~> 2.6.2'
    pod 'SwinjectStoryboard'
    pod 'SwinjectAutoregistration'
    pod 'CryptoSwift'

    pod 'NVActivityIndicatorView'
    pod 'SVProgressHUD'
    pod 'UIWindowTransitions'
    pod 'RxDataSources'
    pod 'SnapKit'
    pod 'UITextView+Placeholder'
end

def test_pods
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    inhibit_all_warnings!

    pod 'SpecLeaks'
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'RxNimble'
    pod 'Quick'
    pod 'Nimble'
end

target 'SwiftNotes' do
  shared_pods
end

target 'SwiftNotesTests' do
  shared_pods
  test_pods
end

target 'SwiftNotesUITests' do
  shared_pods
  test_pods
end