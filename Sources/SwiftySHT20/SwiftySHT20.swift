//
//  SwiftySHT20.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 5/30/19.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

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
    
    // MARK: Temperature & Humidity
    
    /// Reads the sensor's temperature measurement.
    /// - Returns: Temperature object with values in °C and °F
    /// - Throws: Any error while reading the sensor's temperature measurement
    /// - Note: Measured data is transferred in two byte packages, i.e. in frames of 8 bit length where the most significant bit (MSB) is transferred first (left aligned).
    ///         The two status bits, the last bits of LSB, must be set to ‘0’ before calculating physical values.
    public func readTemperature() throws -> Temperature {
        return try readMeasurement(command: .triggerTemperatureReadNoHold)
    }
    
    /// Reads the sensor's relative humidity measurement.
    /// - Returns: Humidity object with value in percentage
    /// - Throws: Any error while reading the sensor's humidity measurement
    /// - Note: Measured data is transferred in two byte packages, i.e. in frames of 8 bit length where the most significant bit (MSB) is transferred first (left aligned).
    ///         The two status bits, the last bits of LSB, must be set to ‘0’ before calculating physical values.
    public func readHumidity() throws -> Humidity {
        return try readMeasurement(command: .triggerHumidityReadNoHold)
    }
    
    // MARK: User Register
    
    /// Reads the content of the sensor's current User Register.
    /// - Returns: The sensor's current User Register
    /// - Throws: Any error while reading the sensor's user register
    public func readUserRegister() throws -> UserRegister {
        try write(command: .readUserRegister)
        let byte = try readByte()
        return UserRegister(rawData: byte)
    }
    
    /// Writes new content to the sensor's User Register.
    /// - Parameter userRegister: The new content to be written
    /// - Throws: Any error while writing data to the sensor's user register
    /// - Note: According to the data sheet, User Register contains reserved bits which must not be manually changed, since its default values
    ///         may change over time without prior notice. Therefore, for any writing to the User Register, default values of reserved bits must be read first and passed on.
    public func writeUserRegister(_ userRegister: UserRegister) throws {
        try write(command: .writeUserRegister)
        try writeByte(command: Constants.continuousWriteCommand, value: userRegister.rawData)
    }
    
    /// Sets the sensor's measurement resolution to a new value.
    /// - Parameter resolution: The new measurement resolution for the sensor
    /// - Throws: Any error while setting the sensor's resolution
    /// - Note: User Register resolution is rh12T14: Humidity 12 bit, Temperature 14 bit by default.
    public func setResolution(_ resolution: UserRegisterMask.Resolution) throws {
        let register = try readUserRegister().setResolution(resolution)
        try writeUserRegister(register)
    }
    
    /// Sets the sensors's on-chip heater status to be either enabled or disabled.
    /// - Parameter isEnabled: Whether heater status is enabled or disabled
    /// - Throws: Any error while enabling/disabling the sensor's on-chip heater
    /// - Note: User Register on-chip heater status is disabled by default.
    public func enableOnChipHeater(_ isEnabled: Bool) throws {
        let register = try readUserRegister().enableOnChipHeater(isEnabled)
        try writeUserRegister(register)
    }
    
    /// Sets the sensor's end of battery alert to be either activated or deactivated.
    /// - Parameter isActive: Whether end of battery alert is activated or deactivated
    /// - Throws: Any error while activating/deactivating the sensor's end of battery alert
    /// - Note: User Register end of battery alert is deactivated by default. This status bit is updated **after each measurement**.
    public func activateEndOfBatteryAlert(_ isActive: Bool) throws {
        let register = try readUserRegister().activateEndOfBatteryAlert(isActive)
        try writeUserRegister(register)
    }
    
    // MARK: Soft Reset
    
    /// Reboots the sensor's system without switching the power off and on again. Upon reception of this command, the sensor system reinitializes and starts operation according to the default settings.
    /// - Throws: Any error while soft resetting the sensor
    /// - Note: The soft reset takes less than 15ms.
    public func softReset() throws {
        print("Starting Soft Reset...🔌")
        
        try write(command: .softReset)
        usleep(Constants.softResetWaitPeriod)
        
        print("Soft Reset Done ✅")
    }
    
    // MARK: Sensor Status
    
    /// Helper function to know the sensor's reachability status.
    /// - Returns: Whether the sensor is reachable or not
    public func isDeviceReachable() -> Bool {
        guard let isReachable = try? i2c.isReachable(deviceAddress) else { return false }
        return isReachable
    }
    
    // MARK: Private Methods
    private func writeByte(command: UInt8 = 0, value: UInt8) throws {
        if command == 0 {
            try i2c.writeByte(deviceAddress, value: value)
        } else {
            try i2c.writeByte(deviceAddress, command: command, value: value)
        }
    }
    
    private func write(command: SensorCommand) throws {
        try writeByte(value: command.rawValue)
    }
    
    private func readByte() throws -> UInt8 {
        return try i2c.readByte(deviceAddress)
    }
        
    private func readMeasurement<T: Measurement>(command: SensorCommand) throws -> T {
        try write(command: command)
        
        usleep(Constants.noHoldWaitPeriod) // Recommended by sensor's data sheet
        
        let msb = try readByte()
        let lsb = try readByte()
        return T(msb: msb, lsb: lsb)
    }
}
