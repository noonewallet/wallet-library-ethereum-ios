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
    
    
    static public let defaultParitetValue: UInt64 = 27
    
    
    let chainIdUInt64: UInt64
    
    
    let chainId: Data
    
    
    let nonce: Data
    
    
    let amount: Data
    
    
    let gasPrice: Data
    
    
    let gasLimit: Data
    
    
    let address: Data
    
    
    let data: Data
    
    
    var v: Data
    
    
    var r: Data
    
    
    var s: Data
    
    
    public var raw: String.HexString {
        
        return (try? serialize().hex) ?? ""
        
    }
    
    
    public var payload: Data {
        
        return (try? serialize()) ?? Data()
        
    }
    
    
    public init(unspentTx: EthereumUnspentTransaction) {
    
        chainIdUInt64 = unspentTx.chainId
        
        chainId = unspentTx.chainId.bigEndian.data
        nonce = unspentTx.nonce.bigEndian.data
        
        amount = unspentTx.amount
        gasPrice = unspentTx.gasPrice
        gasLimit = unspentTx.gasLimit
        
        address = unspentTx.address
        data = unspentTx.data
        
        v = unspentTx.v
        r = unspentTx.r
        s = unspentTx.s
        
    }
    
    
    public func serialize() throws -> Data {
    
        let input = [nonce.dropedPrefixZeros,
                     gasPrice.dropedPrefixZeros,
                     gasLimit.dropedPrefixZeros,
                     address,
                     amount.dropedPrefixZeros,
                     data.dropedPrefixZeros,
                     v.dropedPrefixZeros,
                     r.dropedPrefixZeros,
                     s.dropedPrefixZeros]
        
        let result = try RLP.encode(input)
        
        return result
    }
    
    
    /// Signs a transaction using a set of private key bytes
    /// - Parameter key: Ethereum private key data
    public func sign(key: Data) throws {
        
        let hash = try serialize().keccak()
        
        var recid: Int = 0
        let signature = SignatureECDSA.sign(nonce: .RFC6979, output: .Compact, data: hash, key: key, recid: &recid)
        
        guard SignatureECDSA.validate(signature: signature, data: hash, for: key, type: .Compact) else {
            
            throw EthereumCreateTransactionError.wrongSignature
            
        }
        
        var index: UInt64 = 0
        
        if chainIdUInt64 > 0 {
            
            index = (chainIdUInt64 * 2) + 8
            
        }
        
        index += UInt64(recid) + EthereumTransaction.defaultParitetValue
        
        v = index.bigEndian.data.dropedPrefixZeros
        r = signature.subdata(in: 0..<32)
        s = signature.subdata(in: 32..<64)
        
    }
    
    
}




// MARK: - CustomStringConvertible

extension EthereumTransaction: CustomStringConvertible {
    
    public var description: String {
        """
        ETHEREUM_TRANSACTION
        CHAIN: \(HexConverter.convertToDecimalString(fromHexString: chainId.hex))
        CHAIN HEX: \(chainId.hex)
        NONCE: \(HexConverter.convertToDecimalString(fromHexString: nonce.hex))
        NONCE HEX: \(nonce.hex)
        AMOUNT: \(HexConverter.convertToDecimalString(fromHexString: amount.hex))
        AMOUNT HEX: \(amount.hex)
        ADDRESS: \(address.hex)
        GAS_PRICE: \(HexConverter.convertToDecimalString(fromHexString: gasPrice.hex))
        GAS_PRICE HEX: \(gasPrice.hex)
        GAS_LIMIT: \(HexConverter.convertToDecimalString(fromHexString: gasLimit.hex))
        GAS_LIMIT HEX: \(gasLimit.hex)
        DATA: \(data.hex)
        V: \(v.hex)
        R: \(r.hex)
        S: \(s.hex)
        """
    }
}
