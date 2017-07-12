//
//  Message.swift
//  whoisthere
//
//  Created by Efe Kocabas on 12/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation

struct Message {
    
    var text : String
    var isSent : Bool
    
    init(text: String, isSent: Bool) {
        
        self.text = text
        self.isSent = isSent
    }
}
