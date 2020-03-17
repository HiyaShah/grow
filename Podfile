project 'Grow.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
    pod 'Firebase/Core', '6.1.0'
    pod 'Firebase/Auth', '6.1.0'
    pod 'Firebase/Firestore', '6.1.0'
    pod 'Firebase/Storage', '6.1.0'
    pod 'Firebase/Functions', '6.1.0'
    pod 'IQKeyboardManagerSwift', '6.3.0'
    pod 'Kingfisher', '~> 4.0'
    pod 'CodableFirebase'
end

target 'Grow' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Grow
  shared_pods
  pod 'Stripe'
  pod 'Alamofire'
  

  target 'GrowTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GrowUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'GrowAdmin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GrowAdmin
  shared_pods
  
  target 'GrowAdminTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GrowAdminUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
