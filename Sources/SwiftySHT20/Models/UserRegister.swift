//
//  UserRegister.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 5/30/19.
//

import Foundation

public struct UserRegister {
    // MARK: Variables Declaration
    
    /// Disables OTP reload. Default value is **true**.
    /// - Note: According to data sheet, this feature is disabled per default and is not recommended for use. Please use SoftReset instead.
    public let isOTPReloadDisabled: Bool
    
    /// Enables on chip heater. Default value is **false**.
    /// - Note: The heater is intended to be used for functionality diagnosis. Relative humidity drops upon rising temperature. The heater consumes about 5.5mW and provides a temperature increase of about 0.5 – 1.5°C.
    public let isOnChipHeaterEnabled: Bool
    
    /// Activates end of battery alert. Default value is **false**
    /// - Note: Alert is activated when the battery power falls below 2.25V
    public let isEndOfBatteryActivated: Bool
    
    /// The sensor's measurement resolution. Default value is **rh12T14: Humidity 12 bit, Temperature 14 bit**.
    public let measurementResolution: UserRegisterMask.Resolution?
    
    /// The User Register's raw data
    public let rawData: UInt8
    
    // MARK: Initializer
    public init(rawData: UInt8) {
        self.rawData = rawData
        self.isOTPReloadDisabled = (rawData & UserRegisterMask.disableOTPReload.rawValue).toBool()
        self.isOnChipHeaterEnabled = (rawData & UserRegisterMask.enableOnChipHeater.rawValue).toBool()
        self.isEndOfBatteryActivated = (rawData & UserRegisterMask.statusEndOfBattery.rawValue).toBool()
        self.measurementResolution = UserRegisterMask.Resolution(rawValue: rawData & Constants.resolutionMask)
    }
    
    // MARK: Public Methods
    
    /// Sets the new User Register's resolution.
    /// - Parameter newResolution: The User Register's new resolution.
    /// - Returns: The User Register with the new resolution.
    public func setResolution(_ newResolution: UserRegisterMask.Resolution) -> UserRegister {
        let resetData = rawData & Constants.resolutionResetMask
        let newRawData = resetData | newResolution.rawValue
        return UserRegister(rawData: newRawData)
    }
}
