//
//  UInt8+Extensions.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 5/30/19.
//

import Foundation

extension UInt8 {
    func toBool() -> Bool {
        return self != 0x00
    }
}
