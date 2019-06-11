//
//  Temperature.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 6/11/19.
//

import Foundation

public struct Temperature {
    // MARK: Variables Declaration
    
    /// The temperature measurement raw data
    public let rawData: UInt16
    
    /// The temperature measurement in °C
    public let cValue: Float
    
    /// The temperature measurement in °F
    public let fValue: Float
    
    // MARK: Initializer
    public init(msb: UInt8, lsb: UInt8) {
        let mergedBits = (UInt16(msb) << Constants.leftShift16Bits) | UInt16(lsb)
        let filteredBits = mergedBits & Constants.measurementReading14BitsMask
        
        self.rawData = filteredBits
        self.cValue = -46.85 + ((Float(rawData) * 175.72) / 65536) // Formula obtained from data sheet
        self.fValue = cValue * 1.8 + 32
    }
}
