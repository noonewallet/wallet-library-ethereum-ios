//
//  EthereumTransactionEIP1559Parameters.swift
//  WalletLibEthereum
//
//

import Foundation
import WalletLibCrypto
import WalletLibRLP
import WalletLibCrypto.HexConverter


public class EthereumTransactionEIP1559Parameters: EthereumTransactionParametersProtocol {
    
    
    public var version: UInt8
    
    
    public var chainid: UInt64
    
    
    public var nonce: Int
    
    
    public var value: String.HexString
    
    
    public var address: String
    
    
    public var maxPriorityFeePerGas: String.HexString
    
    
    public var maxFeePerGas: String.HexString
    
    
    public var gasLimit: String.HexString
    
    
    public var input: String.HexString
    
    
    public var accessList: [Data]
    
    
    public init(version: UInt8 = 0x02,
                chainid: UInt64,
                nonce: Int,
                value: String.HexString,
                address: String.HexString,
                maxPriorityFeePerGas: String.HexString,
                maxFeePerGas: String.HexString,
                gasLimit: String.HexString,
                input: String.HexString,
                accessList: [Data] = [Data]()) {
        
        self.version = version
        
        self.chainid = chainid
        
        self.nonce = nonce
        
        self.value = value
        
        self.address = address
        
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
        
        self.maxFeePerGas = maxFeePerGas
        
        self.gasLimit = gasLimit
        
        self.input = input
        
        self.accessList = accessList
        
    }
    
    
    public func payload() throws -> Data {
    
        let input: [Any] = [
            chainid.bigEndian.data.dropedPrefixZeros,
            nonce.bigEndian.data.dropedPrefixZeros,
            Data(hex: maxPriorityFeePerGas).dropedPrefixZeros,
            Data(hex: maxFeePerGas).dropedPrefixZeros,
            Data(hex: gasLimit).dropedPrefixZeros,
            Data(hex: address),
            Data(hex: value).dropedPrefixZeros,
            Data(hex: input),
            accessList
        ]
        
        let encoded = try RLP.encode(input)
        
        return version.data + encoded
        
    }
    
    
    public func raw(signature: EthereumSignature) throws -> Data {
        
        let input: [Any] = [
            chainid.bigEndian.data.dropedPrefixZeros,
            nonce.bigEndian.data.dropedPrefixZeros,
            Data(hex: maxPriorityFeePerGas).dropedPrefixZeros,
            Data(hex: maxFeePerGas).dropedPrefixZeros,
            Data(hex: gasLimit).dropedPrefixZeros,
            Data(hex: address),
            Data(hex: value).dropedPrefixZeros,
            Data(hex: input),
            accessList,
            signature.v.bigEndian.data.dropedPrefixZeros,
            signature.r.dropedPrefixZeros,
            signature.s.dropedPrefixZeros
        ]
        
        let encoded = try RLP.encode(input)
        
        return version.data + encoded
        
    }
    
    
    
}




// MARK: - CustomStringConvertible

extension EthereumTransactionEIP1559Parameters: CustomStringConvertible {
    
    public var description: String {
        """
        ETHEREUM_TRANSACTION PARAMETERS
        VERSION: \(version)
        CHAIN: \(HexConverter.convertToDecimalString(fromHexString: chainid.data.hex))
        CHAIN HEX: \(chainid.data.hex)
        NONCE: \(nonce))
        NONCE HEX: \(nonce.data.hex)
        AMOUNT: \(HexConverter.convertToDecimalString(fromHexString: value))
        AMOUNT HEX: \(value)
        ADDRESS: \(address)
        MAX_PRIORITY_FEE_PER_GAS: \(HexConverter.convertToDecimalString(fromHexString: maxPriorityFeePerGas))
        MAX_PRIORITY_FEE_PER_GAS HEX: \(maxPriorityFeePerGas)
        MAX_FEE_PER_GAS: \(HexConverter.convertToDecimalString(fromHexString: maxFeePerGas))
        MAX_FEE_PER_GAS HEX: \(maxFeePerGas)
        GAS_LIMIT: \(HexConverter.convertToDecimalString(fromHexString: gasLimit))
        GAS_LIMIT HEX: \(gasLimit)
        INPUT: \(input)
        """
    }
}
