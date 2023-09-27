//
//  EthereumTransactionParametersProtocol.swift
//  WalletLibEthereum
//
//

import Foundation


public protocol EthereumTransactionParametersProtocol: CustomStringConvertible {
    
    
    func payload() throws -> Data
    
    
    func raw(signature: EthereumSignature) throws -> Data
    
    
}
