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
    /// - Note: Measured data is transferred in two byte packages, i.e. in frames of 8 bit length where the most significant bit (MSB) is transferred first (left aligned).
    /// The two status bits, the last bits of LSB, must be set to ‘0’ before calculating physical values.
    public func readTemperature() -> Temperature {
        return readMeasurement(command: .triggerTemperatureReadNoHold)
    }
    
    /// Reads the sensor's relative humidity measurement.
    /// - Returns: Humidity object with value in percentage
    /// - Note: Measured data is transferred in two byte packages, i.e. in frames of 8 bit length where the most significant bit (MSB) is transferred first (left aligned).
    /// The two status bits, the last bits of LSB, must be set to ‘0’ before calculating physical values.
    public func readHumidity() -> Humidity {
        return readMeasurement(command: .triggerHumidityReadNoHold)
    }
    
    // MARK: User Register
    
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
    /// - Note: User Register resolution is rh12T14: Humidity 12 bit, Temperature 14 bit by default.
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
    
    /// Sets the sensor's end of battery alert to be either activated or deactivated.
    /// - Parameter isActive: Whether end of battery alert is activated or deactivated
    /// - Note: User Register end of battery alert is deactivated by default. This status bit is updated **after each measurement**.
    public func activateEndOfBatteryAlert(_ isActive: Bool) {
        let register = readUserRegister().activateEndOfBatteryAlert(isActive)
        writeUserRegister(register)
    }
    
    // MARK: Soft Reset
    
    /// Reboots the sensor system without switching the power off and on again. Upon reception of this command, the sensor system reinitializes and starts operation according to the default settings.
    /// - Note: The soft reset takes less than 15ms.
    public func softReset() {
        print("Soft Reset: Starting 🚗")
        
        write(command: .softReset)
        usleep(Constants.softResetWaitPeriod)
        
        print("Soft Reset: Done ✅")
    }
    
    // MARK: Sensor Status
    
    /// Helper function to know the sensor's reachability status.
    /// - Returns: Whether the sensor is reachable or not
    public func isDeviceReachable() -> Bool {
        return i2c.isReachable(deviceAddress)
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
    
    private func readMeasurement<T: Measurement>(command: SensorCommand) -> T {
        write(command: command)
        usleep(Constants.noHoldWaitPeriod) // Recommended by sensor's data sheet
        let msb = readByte()
        let lsb = readByte()
        return T(msb: msb, lsb: lsb)
    }
}
