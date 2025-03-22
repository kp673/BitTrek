//
//  Statistics.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import Foundation

struct Statistics: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let percentage: Double?
    
    init(title: String, value: String, percentage: Double? = nil) {
        self.title = title
        self.value = value
        self.percentage = percentage
    }
}
