//
//  TransactionTest.swift
//  WalletLibEthereumTests
//
//

import XCTest
@testable import WalletLibCrypto
@testable import WalletLibEthereum
@testable import WalletLibCrypto.HexConverter


final class TransactionTest: XCTestCase {

    
    private let DEFAULT_SLIP0132: ([UInt8], [UInt8]) = ([0x04, 0x88, 0xB2, 0x1E], [0x04, 0x88, 0xAD, 0xE4])
    
    
    func testCreateEthereumTransaction() {

        for testItem in EthereumTransactionTestVector.vector {
            
            let params = EthereumTransactionLegacyParameters(chainid: UInt64(testItem.chainId),
                                                             nonce: testItem.nonce,
                                                             value: HexConverter.convertToHexString(fromDecimalString: testItem.amount),
                                                             address: testItem.address,
                                                             gasPrice: HexConverter.convertToHexString(fromDecimalString: testItem.gasPrice),
                                                             gasLimit: HexConverter.convertToHexString(fromDecimalString: testItem.gasLimit),
                                                             input: testItem.data ?? "")
            
            let transaction = EthereumTransaction(parameters: params)
            
            let seed = Data(hex: "bb0a3858dfbca088a736663740c7ff884a1a1d28f9efac125b79c9edf551577dc43da97676f0ccc58a82c63ca02d44fddc4b5d57a8302be256ebaa3e9bdfe4bb")
            
            let derivation = HDDerivation(seed: seed, slip0132: DEFAULT_SLIP0132)
            try! derivation.derive(for: "m/44'/60'/0'/0/0")
            
            try? transaction.sign(key: derivation.derived.key.data)
            derivation.reset()
            
            XCTAssertFalse(testItem.resultRaw != transaction.raw, "Wrong raw transaction Expected: \(testItem.resultRaw) Result: \(transaction.raw)")
            
        }
        
    }
    

}
