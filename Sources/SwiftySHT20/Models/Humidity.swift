//
//  Humidity.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 6/11/19.
//

import Foundation

public struct Humidity: Measurement {
    // MARK: Variables Declaration
    
    /// The relative humidity raw data
    public let rawData: UInt16
    
    /// The relative humidity measurement in percentage
    public let value: Float
    
    // MARK: Initializer
    public init(msb: UInt8, lsb: UInt8) {
        let mergedBits = (UInt16(msb) << Constants.leftShift16Bits) | UInt16(lsb)
        let filteredBits = mergedBits & Constants.measurementReading14BitsMask
        
        self.rawData = filteredBits
        self.value = -6 + ((Float(filteredBits) * 125.0) / 65536.0) // Formula obtained from data sheet
    }
}
