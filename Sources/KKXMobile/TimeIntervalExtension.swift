//
//  TimeIntervalExtension.swift
//  KKXMobile
//
//  Created by ming on 2021/5/10.
//

import UIKit

extension Int {
    public static let aSecond: Int = 1
    public static let aMinute: Int = 60
    public static let aHour: Int   = 60 * 60
    public static let aDay: Int    = 60 * 60 * 24
    public static let aWeek: Int   = 60 * 60 * 24 * 7
}

extension Double {
    
    /// 时间戳（毫秒）转成时间格式字符串(自定义格式)
    ///
    ///     let millisecond = 3_600_000
    ///     let string1 = millisecond.convertToString()
    ///     // string1 = "01:00:00"
    ///
    ///     let string2 = millisecond.convertToString("HH时mm分")
    ///     // string2 = "01时00分
    ///
    /// - Parameter formater: 日期格式，默认 yyyy-MM-dd HH:mm:ss
    /// - Parameter timeZone: 时区，默认为nil，即系统时区
    /// - Returns: formater格式字符串
    public func convertToString(_ formater: Date.Formatter = .dateAndTime, timeZone: TimeZone? = nil) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formater.rawValue
        if timeZone != nil {
            dateFormater.timeZone = timeZone
        }
        let date = Date(timeIntervalSince1970: self/1000.0)
        return dateFormater.string(from: date)
    }
}
