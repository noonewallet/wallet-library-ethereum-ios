//
//  EthereumTransaction.swift
//  WalletLibEthereum
//
//

import Foundation
import WalletLibCrypto
import WalletLibRLP
import WalletLibCrypto.HexConverter


/// An object for displaying and working with Ethereum transaction
public class EthereumTransaction {
    
    
    let parameters: EthereumTransactionParametersProtocol
    
    
    var signature: EthereumSignature?
    
    
    public var raw: String.HexString {
        
        guard let `signature` = signature, let serialized = (try? parameters.raw(signature: signature))?.hex else {
            
            return ""
            
        }
        
        return serialized
        
    }
    
    
    public init(parameters: EthereumTransactionParametersProtocol) {
        
        self.parameters = parameters
        
    }
    
    
    public func sign(key: Data) throws {
        
        let hash = try parameters.payload().keccak()
        
        var recid: Int = 0
        
        let signature = SignatureECDSA.sign(nonce: .RFC6979, output: .Compact, data: hash, key: key, recid: &recid)
        
        guard SignatureECDSA.validate(signature: signature, data: hash, for: key, type: .Compact) else {
            
            throw EthereumCreateTransactionError.wrongSignature
            
        }
        
        
        self.signature = EthereumSignature(v: UInt64(recid), r: signature.subdata(in: 0..<32), s: signature.subdata(in: 32..<64))
        
    }
    
    
}




// MARK: - CustomStringConvertible

extension EthereumTransaction: CustomStringConvertible {
    
    public var description: String {
        """
        ETHEREUM_TRANSACTION
        \(parameters.description)
        V: \(signature?.v.data.hex ?? "")
        R: \(signature?.r.hex ?? "")
        S: \(signature?.s.hex ?? "")
        """
    }
}
