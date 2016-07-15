import UIKit
import RealmSwift

class InputTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private let realm = RealmModelManager.sharedManager
    private var reference = "プリント"
    private var closeAt = NSDate()
    private var subjects: Results<Subject>?
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var subjectSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        let homeworks = realm.findAllObjects(Homework.self)
        print(TimezoneConverter.convertToJST(NSDate()))
        print(homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))
        deadlineDatePicker.date = NSDate(timeInterval: 24*60*60*7, sinceDate: NSDate())
        subjects = realm.findAllObjects(Subject)
        
        for (i, subject) in subjects!.enumerate(){
            subjectSegmentedControl.setTitle(subject.name, forSegmentAtIndex: i)
        }
        closeAt = TimezoneConverter.convertToJST(NSDate(timeIntervalSinceNow: 7*24*60*60))
        subjectSegmentedControl.tintColor = UIColor.hexStr(subjects![0].hexColor, alpha: 1)
 
    }

    
    
    @IBAction func subjectSegmentedControl(sender: UISegmentedControl) {
        var index = subjectSegmentedControl.selectedSegmentIndex
        var selectedSubjectColor = UIColor.hexStr(subjects![index].hexColor, alpha: 1)
        self.subjectSegmentedControl.tintColor = selectedSubjectColor
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
        closeAt = TimezoneConverter.convertToJST(date!)
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
        cell.subjectNameLabel.text = (homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))[indexPath.row].subject!.name
        cell.backgroundColor = UIColor.hexStr((homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))[indexPath.row].subject!.hexColor, alpha: 1)
        return cell
    }
    
    @IBAction func saveUIButtonTouchUpInside(sender: UIButton) {
        var subject = subjects![subjectSegmentedControl.selectedSegmentIndex]
        var homework = Homework()
        homework.subject = subject
        homework.reference = reference
        homework.closeAt = closeAt
        homework.createdAt = TimezoneConverter.convertToJST((NSDate()))
        
        realm.create(Homework.self, value: homework)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelUIButtonTouchUpInside(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
