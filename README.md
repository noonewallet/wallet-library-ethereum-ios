
[![License](https://img.shields.io/badge/license-MIT-black.svg?style=flat)](https://mit-license.org)
[![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/resources/)
[![Swift](https://img.shields.io/badge/swift-5.0-brightgreen.svg)](https://developer.apple.com/resources/)
[![Version](https://img.shields.io/badge/Version-1.0-orange.svg)]()

![Noone core](https://github.com/noonewallet/noone-android-core-crypto/assets/111989613/1f062349-24d4-4824-9c00-b8f2724eca51)

## WalletLibEthereum

The WalletLibEthereum library is an implementation of tools related to Ethereum blockchain.
## Requirements

* macOS 12.6
* XCode Version 14.2

## Installation

Using `CocoaPods`. 

Clone or download repo, add the following line to your `Podfile`

```ruby
# platform :ios, '10.0'

target 'YourTargetName' do
  use_frameworks!
  
  pod 'WalletLibEthereum', :path => 'path/to/WalletLibEthereum' 
end
```

## Usage

#### Generating address
```swift

    let key = Data(hex: "04e10667e02525d16bdad8a62ad6c3adbb5a5c8f2c6a18d6e5bd6d7a7ffd85641ac7c1baf36ee9c11a730c90a18626d451ff64171ec270afa6ae4ceb075cee4eaa")

    let ethereumAddress = try! EthereumAddress(data: key)

```

#### Transaction signing

```swift
    
    let params = EthereumTransactionLegacyParameters(chainid: 1,
                                                 nonce: 42,
                                                 value: HexConverter.convertToHexString(fromDecimalString: "4000000000000000"),
                                                 address: "0x02dcc1a806685569e37cbc962510daea40a83618",
                                                 gasPrice: HexConverter.convertToHexString(fromDecimalString: "2500000000"),
                                                 gasLimit: HexConverter.convertToHexString(fromDecimalString: "21000"),
                                                 input: "")
            
    let transaction = EthereumTransaction(parameters: params)
            
    let seed = Data(hex: "bb0a3858dfbca088a736663740c7ff884a1a1d28f9efac125b79c9edf551577dc43da97676f0ccc58a82c63ca02d44fddc4b5d57a8302be256ebaa3e9bdfe4bb")

    let DEFAULT_SLIP0132: ([UInt8], [UInt8]) = ([0x04, 0x88, 0xB2, 0x1E], [0x04, 0x88, 0xAD, 0xE4])
        
    let derivation = HDDerivation(seed: seed, slip0132: DEFAULT_SLIP0132)
    
    try! derivation.derive(for: "m/44'/60'/0'/0/0")
            
    try? transaction.sign(key: derivation.derived.key.data)
    
    derivation.reset()

```

## Created using
* [_WalletLibCrypto_](https://github.com/noonewallet/wallet-library-crypto-ios)
* [_WalletLibRLP_](https://github.com/noonewallet/wallet-library-rlp-ios)

## License

MIT. See the [_LICENSE_](LICENSE) file for more info.
