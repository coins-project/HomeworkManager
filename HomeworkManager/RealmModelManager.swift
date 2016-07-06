import RealmSwift

class RealmModelManager {
    
    static let sharedManager = RealmModelManager()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    internal func findAllObjects<T: Model>(type: T.Type) -> Results<T> {
        return self.realm.objects(type)
    }
    
    internal func findAllObjectsBy<T: Model>(type: T.Type, filter: NSPredicate) -> Results<T> {
        return self.realm.objects(type).filter(filter)
    }
    
    internal func find<T: Model>(type: T.Type, id: String) -> T? {
        return self.realm.objectForPrimaryKey(type, key: id)
    }
    
    internal func findBy<T: Model>(type: T.Type, filter: NSPredicate) -> T {
        return self.realm.objects(type).filter(filter)[0]
    }
}
