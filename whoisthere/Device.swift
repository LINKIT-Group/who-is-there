//
//  Peripheral.swift
//  whoisthere
//
//  Created by Efe Kocabas on 06/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {
    
    var peripheral : CBPeripheral
    var name : String
    var messages = Array<String>()
    
    init(peripheral: CBPeripheral, name:String) {
        self.peripheral = peripheral
        self.name = name
    }
}
