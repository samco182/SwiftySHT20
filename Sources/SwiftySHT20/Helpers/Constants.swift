//
//  Constants.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 5/30/19.
//

import Foundation

public enum SensorCommand: UInt8 {
    case triggerTemperatureReadHold = 0xE3 // Binary: 1110 0011
    case triggerHumidityReadHold = 0xE5 // Binary: 1110 0101
    case triggerTemperatureReadNoHold = 0xF3 // Binary: 1111 0011
    case triggerHumidityReadNoHold = 0xF5 // Binary: 1111 0101
    case writeUserRegister = 0xE6 // Binary: 1110 0110
    case readUserRegister = 0xE7 // Binary: 1110 0111
    case softReset = 0xFE // Binary: 1111 1110
}

public enum UserRegisterMask: UInt8 {
    case disableOTPReload = 0x02 // Bit 1
    case enableOnChipHeater = 0x04 // Bit 2
    case statusEndOfBattery = 0x40 // Bit 6
    
    public enum Resolution: UInt8 {
        case rh12T14 = 0x00 // Bit 7,0: '00'
        case rh8T12 = 0x01 // Bit 7,0: '01'
        case rh10T3 = 0x80 // Bit 7,0: '10
        case rh11T11 = 0x81 // Bit 7,0: '11'
    }
}

public enum UserRegisterResetMask: UInt8 {
    case resolution = 0x7E // Binary: 0111 1110
    case enableOnChipHeater = 0xFB // Binary: 1111 1011
}

public enum Constants {
    public static let deviceAddress: Int = 0x40 // Binary: 0100 0000
    public static let resolutionMask: UInt8 = 0x81 // Binary: 1000 0001
    public static let continuousWriteCommand: UInt8 = 0xE6 // Binary: 1110 0110
    public static let noHoldWaitPeriod: Int = 20 // Micro-seconds
}
