//
//  TimeZone+Util.swift
//  Clock
//
//  Created by 전율 on 10/10/24.
//

import Foundation

enum KoreanCity:String {
    case Seoul
    case Paris
    case New_York
    case Tehran
    
    func gerKoreaCity()->String{
        switch self {
        case .Seoul:
            return "서울"
        case .Paris:
            return "파리"
        case .New_York:
            return "뉴욕"
        case .Tehran:
            return "테헤란"
        }
    }
    
}

fileprivate let formtter = DateFormatter()
fileprivate let offsetFormatter = DateComponentsFormatter()

extension TimeZone {
    
    // 현재 시간을 포매팅해서 반환
    var currentTime: String? {
        formtter.timeZone = self
        formtter.dateFormat = "h:mm"
        return formtter.string(from: .now)
    }
    
    // 오전 오후 반환
    var timePeriod: String? {
        formtter.timeZone = self
        formtter.dateFormat = "a"
        return formtter.string(from: .now)
    }
    
    // 도시 이름 반환
    var city: String {
        let id = identifier
        let city = id.components(separatedBy: "/").last
        return KoreanCity(rawValue: city!)!.gerKoreaCity()
    }
    
    // 시차 반환
    var timeOffset: String? {
        // 표준시 - 내 위치 시간대가 GMT와 얼마나 차이가 나는지 (초 단위)
        let offset = secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let prefix = offset >= 0 ? "+" : ""
        let comp = DateComponents(second: offset)
        
        if offset.isMultiple(of: 3600) {
            offsetFormatter.allowedUnits = [.hour]
            offsetFormatter.unitsStyle = .full
        } else {
            offsetFormatter.allowedUnits = [.hour,.minute]
            offsetFormatter.unitsStyle = .positional
        }
        
        let offsetStr = offsetFormatter.string(from: comp) ?? "\(offset / 3600)시간"
        let time = Date(timeIntervalSinceNow: TimeInterval(offset))
        let cal = Calendar.current
        if cal.isDateInToday(time) {
            return "오늘, \(prefix)\(offsetStr.replacingOccurrences(of: "hours", with: "시간"))"
        } else if cal.isDateInYesterday(time) {
            return "어제, \(prefix)\(offsetStr.replacingOccurrences(of: "hours", with: "시간"))"
        } else if cal.isDateInTomorrow(time) {
            return "내일, \(prefix)\(offsetStr.replacingOccurrences(of: "hours", with: "시간"))"
        } else {
            return nil
        }
    }
    
}
