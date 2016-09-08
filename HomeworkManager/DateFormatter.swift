//
//  DateFormatter.swift
//  HomeworkManager
//
//  Created by 古川 和輝 on 2016/09/09.
//  Copyright © 2016年 takayuki abe. All rights reserved.
//

import Foundation

class DateFormatter {
    class func stringFromDate(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
        return formatter.stringFromDate(date)
    }
}