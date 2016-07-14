import UIKit
import RealmSwift

class InputTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private let realm = RealmModelManager.sharedManager
    private var subjectName = "国語"
    private var subjectColor = ""
    private var reference = "プリント"
    private var closeAt = NSDate()
        
    
    override func viewDidLoad() {
        let homeworks = realm.findAllObjects(Homework.self)
        print(TimezoneConverter.convertToJST(NSDate()))
        print(homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))
        
    }
    
    
    
    @IBAction func subjectSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            subjectName = "国語"
            subjectColor = ""
        case 1:
            subjectName = "数学"
            subjectColor = ""
        case 2:
            subjectName = "理科"
            subjectColor = ""
        case 3:
            subjectName = "社会"
            subjectColor = ""
        case 4:
            subjectName = "英語"
            subjectColor = ""
        default:
            subjectName = ""
            subjectColor = ""
        }
        
    }
    
    @IBAction func referenceSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            reference = "プリント"
        case 1:
            reference = "教科書"
        default:
            reference = ""
        }
    }
    
    @IBAction func deadlineDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
        let date = dateFormatter.dateFromString(dateFormatter.stringFromDate(sender.date))
        closeAt = TimezoneConverter.convertToJST((NSDate()))
        }
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let homeworks = realm.findAllObjects(Homework.self)
        return (homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate())))).count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! TodayHomeworkCollectionViewCell) ?? TodayHomeworkCollectionViewCell()
        let homeworks = realm.findAllObjects(Homework.self)
        cell.subjectNameLabel.text = (homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))[indexPath.row].subjects[0].name
        return cell
    }
    
    @IBAction func saveUIButtonTouchUpInside(sender: UIButton) {
        var subjects: List<Subject> = List<Subject>()
        var subject = Subject()
        var homework = Homework()
        subject.name = subjectName
        subject.hexColor = subjectColor
        subjects.append(subject)
        homework.subjects = subjects
        homework.reference = reference
        homework.closeAt = closeAt
        homework.createdAt = TimezoneConverter.convertToJST((NSDate()))
        
        realm.create(Homework.self, value: homework)
    }
    
    @IBAction func cancelUIButtonTouchUpInside(sender: UIButton) {
    }
    
}
