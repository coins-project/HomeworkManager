import UIKit
import RealmSwift
class Homework: Object {
    dynamic var id: Int = 0
    dynamic var subject: Subject = Subject()
    dynamic var createdAt: NSDate = NSDate()
    dynamic var closeAt: NSDate = NSDate()
    dynamic var finished: Bool = false
    dynamic var photo: Photo = Photo()
    dynamic var reference: Int = 0
}
