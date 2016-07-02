import UIKit
import RealmSwift
class Homework: Object {
    dynamic var id: Int = 0
    let subjects: List<Subject> = List<Subject>()
    dynamic var createdAt: NSDate = NSDate()
    dynamic var closeAt: NSDate = NSDate()
    dynamic var finished: Bool = false
    let photos: List<Photo> = List<Photo>()
    dynamic var reference: Int = 0
}
