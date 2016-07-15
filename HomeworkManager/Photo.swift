import UIKit
import RealmSwift

class Photo: Model {
    
    dynamic var url: String = ""
    dynamic var createdAt: NSDate = NSDate()
    let homeworks = List<Homework>()
    
}
