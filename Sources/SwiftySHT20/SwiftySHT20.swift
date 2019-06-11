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
    
    // MARK: Initializers
    public init(for board: SupportedBoard) {
        let i2cs = SwiftyGPIO.hardwareI2Cs(for: board)!
        self.i2c = i2cs[1] // not sure what i2cs[0] is ...
    }
    
    public convenience init() {
        self.init(for: .RaspberryPi3)
    }
    
    
    public init(text: String = "Hello, World!") {
        self.text = text
    }
}
