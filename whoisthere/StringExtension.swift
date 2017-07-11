//
//  StringExtension.swift
//  whoisthere
//
//  Created by Efe Kocabas on 11/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation 

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
