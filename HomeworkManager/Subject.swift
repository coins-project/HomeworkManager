import UIKit
import RealmSwift

class Subject: Model {
    
    dynamic var name = ""
    dynamic var hexColor = ""
    let homeworks = List<Homework>()
    
}
