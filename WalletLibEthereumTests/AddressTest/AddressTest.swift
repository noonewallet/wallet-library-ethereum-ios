//
//  AddressTest.swift
//  WalletLibEthereumTests
//
//

import XCTest
@testable import WalletLibEthereum


final class AddressTest: XCTestCase {

    
    func testEthereumAddressses() {
        
        for element in EthereumAddressTestVector.vector {
            
            let ethereumAddress = try! EthereumAddress(data: Data(hex: element.key))
            
            XCTAssertFalse(ethereumAddress.address != element.address, "Wrong address Expected: \(element.address) Result: \( ethereumAddress.address)")
            
        }
        
    }

    
}
