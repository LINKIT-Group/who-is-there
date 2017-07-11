//
//  Peripheral.swift
//  whoisthere
//
//  Created by Efe Kocabas on 06/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Peripheral {
    
    var item : CBPeripheral
    var name : String
    
    init(item: CBPeripheral, name:String) {
        self.item = item
        self.name = name
    }
    
    
}
