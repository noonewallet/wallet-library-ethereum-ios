#
#  Be sure to run `pod spec lint WalletLibEthereum.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "WalletLibEthereum"
  s.version      = "1.0"
  s.summary      = "WalletLibEthereum"
  s.homepage	 = "https://github.com/noonewallet/wallet-library-ethereum-ios"

  s.license      = "MIT"
  s.author       = "WalletLibEthereum"

  s.source       = { :git => "https://github.com/noonewallet/wallet-library-ethereum-ios.git", :tag => "v#{s.version}", :submodules => true }
  s.swift_version = '5.0'

  s.source_files  = 'WalletLibEthereum/*{swift}', 'WalletLibEthereum/**/*{swift}'

  s.ios.dependency 'WalletLibCrypto'
  s.osx.dependency 'WalletLibCrypto'
  s.ios.dependency 'WalletLibRLP'
  s.osx.dependency 'WalletLibRLP'
 
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "11.0"

end
