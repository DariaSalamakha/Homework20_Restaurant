//
//  OrderResponse.swift
//  OrderApp
//
//  Created by Daria Salamakha on 14.05.2022.
//

import Foundation

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
