//
//  Order.swift
//  OrderApp
//
//  Created by Daria Salamakha on 14.05.2022.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
