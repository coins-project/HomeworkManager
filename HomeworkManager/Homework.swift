import UIKit
import RealmSwift

class Homework: Model {
    let subjects: List<Subject> = List<Subject>()
    dynamic var createdAt: NSDate = NSDate()
    dynamic var closeAt: NSDate = NSDate()
    dynamic var finished: Bool = false
    let photos: List<Photo> = List<Photo>()
    dynamic var reference: String = ""
    
    enum Reference: String {
        case paper = "プリント"
        case textbook = "教科書"
    }
}
