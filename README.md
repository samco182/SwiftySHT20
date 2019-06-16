# SwiftySHT20

A Swift library for the I2C SHT20 Humidity and Temperature Sensor.

<p>
<img src="https://img.shields.io/badge/Architecture%20-ARMv6%20%7C%20%20ARMv7%2F8-red.svg"/>
<img src="https://img.shields.io/badge/OS-Raspbian%20%7C%20Debian%20%7C%20Ubuntu-yellow.svg"/>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-4x-brightgreen.svg"/></a>
<a href="https://raw.githubusercontent.com/samco182/SwiftySHT20/master/LICENSE"><img src="https://img.shields.io/badge/Licence-MIT-blue.svg" /></a>
</p>
<img src="https://media.rs-online.com/t_large/R1237351-01.jpg" height="300" width="300">

## Summary
This is a [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO) based library for controlling the SHT20 Humidity and Temperature sensor.

You will be able to read via I2C the sensor's humidity and temperatures values, its internal User Register data, write different configuration to the User Register, and soft reset the device.

For more information regarding the sensor's functionality, you can consult its [datasheet](https://www.sensirion.com/fileadmin/user_upload/customers/sensirion/Dokumente/0_Datasheets/Humidity/Sensirion_Humidity_Sensors_SHT20_Datasheet.pdf).

## Hardware Details
The sensor should be powered using **3.3 V**.

The I2C pins on the RaspberryPi (pin 3 SDA, pin 5 SCL) need to be enabled via `raspi-config` before you can use them (restart required), and by enabling the I2C pins you will lose the ability to use the pins as standard GPIOs.

## Supported Boards
Every board supported by [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO): RaspberryPis, BeagleBones, C.H.I.P., etc...

To use this library, you'll need a Linux ARM board running [Swift 4.x](https://github.com/uraimo/buildSwiftOnARM) 🚗.

The example below will use a Raspberry Pi 3B+  board, but you can easily modify the example to use one of the other supported boards. A full working demo project for the RaspberryPi3B+ is available in the **Example** directory.

## Installation
First of all, makes sure your board is running **Swift 4.x** ⚠️!

Since Swift 4.x supports Swift Package Manager, you only need to add SwiftySHT20 as a dependency in your project's `Package.swift` file:

```swift
let package = Package(
    name: "MyProject",
    dependencies: [
        .package(url: "https://github.com/samco182/SwiftySHT20", from: "1.0.0"),
    ]
    targets: [
        .target(
            name: "MyProject", 
            dependencies: ["SwiftySHT20"]),
    ]
)
```
Then run `swift package update` to install the dependency.

## Usage
The first thing is to initialize an instance of `SwiftySHT20`. Once you have your `sht20` object, you can obtain the sensor's humidity and temperature readings:
```swift
import SwiftySHT20

// You can also initialize the object with SwiftySHT20() which defaults to .RaspberryPi3
let sht20 = SwiftySHT20(for: .RaspberryPi3) 

if sht20.isDeviceReachable() {
    let temperature = sht20.readTemperature()
    let humidity = sht20.readHumidity()

    print(String(format: "Temperature: %.2f °C, ", temperature.cValue))
    print(String(format: "Humidity: %.2f", humidity.value)+"%\n\n")
}
```

If you want to read the sensor's User Register or modify any of its configurable values, you can easily do it by using the following functions:
```swift
// Reading User Register
func readUserRegister() -> UserRegister

// Modifying User Register
func setResolution(_ resolution: UserRegisterMask.Resolution)
func enableOnChipHeater(_ isEnabled: Bool)
func activateEndOfBatteryAlert(_ isActive: Bool)
```

If by any chance you want to reset the sensor, you can easily do it by running the following function without removing the power source:
```swift
func softReset()
```
### Note 🔍
If you encounter some problems connecting to the sensor, or `sht20.isDeviceReachable()` keeps returning `false` you could follow [this i2c debugging guide](https://github.com/uraimo/SwiftyGPIO/blob/master/docs/i2c-debugging.md).

