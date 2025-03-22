//
//  UIApplication+Extensions.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
