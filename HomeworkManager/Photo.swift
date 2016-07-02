import UIKit
import RealmSwift
class Photo: Object {
    dynamic var id: Int = 0
    dynamic var url: String = ""
    dynamic var createdAt: NSDate = NSDate()
}
