//
//  Date+Util.swift
//  Clock
//
//  Created by 전율 on 10/14/24.
//

import Foundation

extension Date {
    
    private static var lastUpdateMinute: Int? = nil
    
    var minuteChanged: Bool {
        guard let last = Self.lastUpdateMinute else {
            Self.lastUpdateMinute = Calendar.current.component(.minute, from: .now)
            return true
        }
        let currentMin = Calendar.current.component(.minute, from: .now)
        
        if last != currentMin {
            Self.lastUpdateMinute = currentMin
            return true
        }
        
        return false
    }
    
}
