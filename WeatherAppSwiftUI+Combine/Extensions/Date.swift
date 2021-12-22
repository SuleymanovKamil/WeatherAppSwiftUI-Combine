//
//  Date+Init.swift
//  Fundea
//
//  Created by Bogdan Filippov on 12.07.2021.
//

import Foundation

extension Date {
    
    func toString(date style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}

