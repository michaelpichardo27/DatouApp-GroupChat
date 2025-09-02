//
//  Item.swift
//  DATOU APP
//
//  Created by Zachary Hill on 8/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
