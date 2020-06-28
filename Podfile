# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def default_pods
pod 'SnapKit', '~> 4.0.0'
pod 'RxSwift',    '~> 4.0'
pod 'RxCocoa',    '~> 4.0'
pod 'SwiftyJSON', '~> 4.0'

end

target 'FlightRadar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FlightRadar
default_pods

  target 'FlightRadarTests' do
    inherit! :search_paths
    # Pods for testing
default_pods
  end

  target 'FlightRadarUITests' do
    # Pods for testing
default_pods
  end

end
