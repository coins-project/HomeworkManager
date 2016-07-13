import UIKit
import Foundation
import Realm
import Realm.Private
import RealmSwift

class Model: Object {
    dynamic var id: String = NSUUID().UUIDString
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
