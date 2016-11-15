import Foundation
import UIKit
import RealmSwift

class InputInitialize {
    var subjects: Results<Subject>?
    
    let realm = RealmModelManager.sharedManager
    var homework = Homework()
    
    
}
