//
//  UserData.swift
//  whoisthere
//
//  Created by Efe Kocabas on 13/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation

struct UserData {
    
    private let userDataKey = "userData"
    
    var name: String = ""
    var avatarId: Int = 0
    var colorId: Int = 0
    
    var hasAllDataFilled: Bool {
        return !name.isEmpty && avatarId > 0
    }
    
    public init(){
        
        if let dictionary = UserDefaults.standard.dictionary(forKey: userDataKey) {
            
            name = dictionary["name"] as? String ?? ""
            avatarId = dictionary["avatarId"] as? Int ?? 0
            colorId = dictionary["colorId"] as? Int ?? 0
        }
    }
    
    public func save() {
        
        var dictionary : Dictionary = Dictionary<String, Any>()
        dictionary["name"] = name
        dictionary["avatarId"] = avatarId
        dictionary["colorId"] = colorId
        
        UserDefaults.standard.set(dictionary, forKey: userDataKey)
    }
    
}
