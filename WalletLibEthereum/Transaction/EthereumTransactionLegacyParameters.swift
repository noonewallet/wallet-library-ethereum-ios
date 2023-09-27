//
//  EthereumTransactionLegacyParameters.swift
//  WalletLibEthereum
//
//

import Foundation
import WalletLibCrypto
import WalletLibRLP
import WalletLibCrypto.HexConverter


public class EthereumTransactionLegacyParameters: EthereumTransactionParametersProtocol {
    
    
    public var chainid: UInt64
    
    
    public var nonce: Int
    
    
    public var value: String.HexString
    
    
    public var address: String
    
    
    public var gasPrice: String.HexString
    
    
    public var gasLimit: String.HexString
    
    
    public var input: String.HexString
    
    
    public init(chainid: UInt64,
                nonce: Int,
                value: String.HexString,
                address: String.HexString,
                gasPrice: String.HexString,
                gasLimit: String.HexString,
                input: String.HexString) {
        
        self.chainid = chainid
        
        self.nonce = nonce
        
        self.value = value
        
        self.address = address
        
        self.gasPrice = gasPrice
        
        self.gasLimit = gasLimit
        
        self.input = input

    }
    
    
    public func payload() throws -> Data {
    
        let input = [
            nonce.bigEndian.data.dropedPrefixZeros,
            Data(hex: gasPrice).dropedPrefixZeros,
            Data(hex: gasLimit).dropedPrefixZeros,
            Data(hex: address),
            Data(hex: value).dropedPrefixZeros,
            Data(hex: input),
            chainid.bigEndian.data.dropedPrefixZeros.dropedPrefixZeros,
            Data(count: 1).dropedPrefixZeros,
            Data(count: 1).dropedPrefixZeros
        ]
        
        let sirialized = try RLP.encode(input)
        
        return sirialized
        
    }
    
    
    public func raw(signature: EthereumSignature) throws -> Data {
        
        var v: UInt64 = 0
        
        if chainid > 0 {
            
            v = (chainid * 2) + 8
            
        }
        
        v += UInt64(signature.v) + 27
        
        let input = [
            nonce.bigEndian.data.dropedPrefixZeros,
            Data(hex: gasPrice).dropedPrefixZeros,
            Data(hex: gasLimit).dropedPrefixZeros,
            Data(hex: address),
            Data(hex: value).dropedPrefixZeros,
            Data(hex: input),
            v.bigEndian.data.dropedPrefixZeros,
            signature.r.dropedPrefixZeros,
            signature.s.dropedPrefixZeros
        ]
        
        let serialized = try RLP.encode(input)
        
        return serialized
        
    }
    
    
    
}




// MARK: - CustomStringConvertible

extension EthereumTransactionLegacyParameters: CustomStringConvertible {
    
    public var description: String {
        """
        ETHEREUM_TRANSACTION PARAMETERS
        CHAIN: \(HexConverter.convertToDecimalString(fromHexString: chainid.data.hex))
        CHAIN HEX: \(chainid.data.hex)
        NONCE: \(nonce))
        NONCE HEX: \(nonce.data.hex)
        AMOUNT: \(HexConverter.convertToDecimalString(fromHexString: value))
        AMOUNT HEX: \(value)
        ADDRESS: \(address)
        GAS_PRICE: \(HexConverter.convertToDecimalString(fromHexString: gasPrice))
        GAS_PRICE HEX: \(gasPrice)
        GAS_LIMIT: \(HexConverter.convertToDecimalString(fromHexString: gasLimit))
        GAS_LIMIT HEX: \(gasLimit)
        INPUT: \(input)
        """
    }
}
