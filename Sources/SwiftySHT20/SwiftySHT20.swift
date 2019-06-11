//
//  SwiftySHT20.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 5/30/19.
//

import SwiftyGPIO

public class SwiftySHT20 {
    // MARK: Variables Declaration
    private let i2c: I2CInterface
    private let deviceAddress = Constants.deviceAddress
    
    // MARK: Initializers
    public init(for board: SupportedBoard) {
        let i2cs = SwiftyGPIO.hardwareI2Cs(for: board)!
        self.i2c = i2cs[1] // not sure what i2cs[0] is ...
    }
    
    public convenience init() {
        self.init(for: .RaspberryPi3)
    }
    
    // MARK: Public Methods
    
    /// Reads the content of the sensor's current User Register.
    /// - Returns: The sensor's current User Register
    public func readUserRegister() -> UserRegister {
        write(command: .readUserRegister)
        let byte = readByte()
        return UserRegister(rawData: byte)
    }
    
    // MARK: Private Methods
    private func write(command: SensorCommand) {
        writeByte(value: command.rawValue)
    }
    
    private func writeByte(value: UInt8) {
        i2c.writeByte(deviceAddress, value: value)
    }
    
    private func readByte() -> UInt8 {
        return i2c.readByte(deviceAddress)
    }
}
