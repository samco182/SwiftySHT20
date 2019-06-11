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
    
    /// Writes new content to the sensor's User Register.
    /// - Parameter userRegister: The new content to be written
    /// - Note: According to the data sheet, User Register contains reserved bits which must not be manually changed, since its default values
    /// may change over time without prior notice. Therefore, for any writing to the User Register, default values of reserved bits must be read first and passed on.
    public func writeUserRegister(_ userRegister: UserRegister) {
        write(command: .writeUserRegister)
        writeByte(command: Constants.continuousWriteCommand, value: userRegister.rawData)
    }
    
    /// Sets the sensor's measurement resolution to a new value.
    /// - Parameter resolution: The new measurement resolution for the sensor
    public func setResolution(_ resolution: UserRegisterMask.Resolution) {
        let register = readUserRegister().setResolution(resolution)
        writeUserRegister(register)
    }
    
    /// Sets the sensors's on-chip heater status to be either enabled or disabled.
    /// - Parameter isEnabled: Whether heater status is enabled or disabled
    /// - Note: User Register on-chip heater status is disabled by default.
    public func enableOnChipHeater(_ isEnabled: Bool) {
        let register = readUserRegister().enableOnChipHeater(isEnabled)
        writeUserRegister(register)
    }
    
    // MARK: Private Methods
    private func write(command: SensorCommand) {
        writeByte(value: command.rawValue)
    }
    
    private func writeByte(command: UInt8 = 0, value: UInt8) {
        if command == 0 {
            i2c.writeByte(deviceAddress, value: value)
        } else {
            i2c.writeByte(deviceAddress, command: command, value: value)
        }
    }
    
    private func readByte() -> UInt8 {
        return i2c.readByte(deviceAddress)
    }
}
