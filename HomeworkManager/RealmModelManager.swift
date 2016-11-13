import RealmSwift

class RealmModelManager {
    
    static let sharedManager = RealmModelManager()
    
    let realm: Realm
    
    private init() {
        try! self.realm = Realm()
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
    
    internal func findBy<T: Model>(type: T.Type, filter: NSPredicate) -> T? {
        let objects = self.realm.objects(type).filter(filter)
        return objects.last
    }
    
    internal func create<T: Model>(type: T.Type, value: AnyObject) {
        do {
            try realm.write { realm.create(type.self, value: value) }
        } catch {
            print("Create model error: RealmModelManager#create<T: Model>(type: T.Type, value: AnyObject)")
        }
    }
    
    internal func create<T: Model>(model: T) {
        do {
            try realm.write { realm.add(model) }
        } catch {
            print("Create model error: RealmModelManager#create<T: Model>(model: T)")
        }
    }
    
    internal func update<T: Model>(type: T.Type, value: AnyObject) {
        do {
            try realm.write { realm.create(type.self, value: value, update: true) }
        } catch {
            print("Update model error: RealmModelManager#update<T: Model>(type: T.Type, value: AnyObject)")
        }
    }
    
    internal func update<T: Model>(model: T) {
        do {
            try realm.write { realm.add(model, update: true) }
        } catch {
            print("Update model error: RealmModelManager#update<T: Model>(model: T)")
        }
    }
    
    internal func update<T: Model>(model: T, value: [String: AnyObject]) {
        do {
            try realm.write {
                for(k, v) in value {
                    model.setValue(v, forKey: k)
                }
            }
        } catch {
            print("Update model error: RealmModelManager#update<T: Model>(model: T, value: [String: AnyObject])")
        }
    }
}
