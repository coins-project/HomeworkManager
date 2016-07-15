import UIKit
import RealmSwift

class Homework: Model {
    
    dynamic var createdAt: NSDate = NSDate()
    dynamic var closeAt: NSDate = NSDate()
    dynamic var finished: Bool = false
    dynamic var reference: String = ""
    dynamic var photo: Photo?
    dynamic var subject: Subject?
    
    enum Reference: String {
        case paper = "プリント"
        case textbook = "教科書"
    }
}
