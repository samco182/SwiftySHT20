import SwiftySHT20

let sht20 = SwiftySHT20(for: .RaspberryPi3)

//// To change the sensor's resolution
//sht20.setResolution(.rh11T11)

while true {
    if sht20.isDeviceReachable() {
        let temperature = sht20.readTemperature()
        let humidity = sht20.readHumidity()
        
        print(String(format: "Temperature: %.2f °C, ", temperature.cValue))
        print(String(format: "Humidity: %.2f", humidity.value)+"%\n\n")
    }
}
