//
//  Double.swift
//  Fundea
//
//  Created by Bogdan Filippov on 25.08.2021.
//

import Foundation

extension Double {
    var nsNumber: NSNumber {
        return NSNumber(value: self)
    }
    
    var integer: Int {
        return nsNumber.intValue
    }
    
    var string: String {
        return nsNumber.stringValue
    }
}
