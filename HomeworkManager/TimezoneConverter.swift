import UIKit

class TimezoneConverter: NSObject {

    class func convertToJST(date: NSDate) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
        let gmt = dateFormatter.dateFromString(dateFormatter.stringFromDate(date))
        return NSDate(timeInterval: 9*60*60, sinceDate: gmt!)
    }
}
