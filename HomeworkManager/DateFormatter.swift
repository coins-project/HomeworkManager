import Foundation

class DateFormatter {
    class func stringFromDate(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
        return formatter.stringFromDate(date)
    }
}
