//
//  Measurement.swift
//  SwiftySHT20
//
//  Created by Samuel Cornejo on 6/11/19.
//

import Foundation

protocol Measurement {
    init(msb: UInt8, lsb: UInt8)
}
