import UIKit
import RealmSwift

class InputTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var homework = Homework()
    private let realm = RealmModelManager.sharedManager
    private var reference: String?
    private var closeAt = NSDate()
    var subjectIndex: Int?
    private var subjects: Results<Subject>?
    private var update = false
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var referenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var subjectList: UICollectionView!
    
    override func viewDidLoad() {
        subjects = realm.findAllObjects(Subject)
        if(homework.subject?.name != nil) {
            update = true
        }
        if(update) {
            deadlineDatePicker.date = homework.closeAt
            closeAt = TimezoneConverter.convertToJST(NSDate(timeIntervalSinceNow: 7*24*60*60))
            if(homework.reference == "教科書") {
                reference = "教科書"
                referenceSegmentedControl.selectedSegmentIndex = 1
            } else {
                reference = "プリント"
                referenceSegmentedControl.selectedSegmentIndex = 0
            }
        } else {
            reference = "プリント"
            deadlineDatePicker.date = NSDate(timeInterval: 24*60*60*7, sinceDate: NSDate())
            closeAt = TimezoneConverter.convertToJST(NSDate(timeIntervalSinceNow: 7*24*60*60))
        }
        closeAt = TimezoneConverter.convertToJST(NSDate(timeIntervalSinceNow: 7*24*60*60))
        configurePlusMinusButton()
    }

    func configurePlusMinusButton() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            minusButton.hidden = true
            plusButton.hidden = true
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
        closeAt = TimezoneConverter.convertToJST(date!)
        }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 0) {
        let homeworks = realm.findAllObjects(Homework.self)
        return (homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate())))).count
        } else {
            return subjects!.count
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView.tag == 0) {
            let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("cell1", forIndexPath: indexPath) as! TodayHomeworkCollectionViewCell) ?? TodayHomeworkCollectionViewCell()
            let homeworks = realm.findAllObjects(Homework.self)
            cell.subjectNameLabel.text = (homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))[indexPath.row].subject!.name
            cell.backgroundColor = UIColor.hexStr((homeworks.filter(NSPredicate(format: "createdAt == %@", TimezoneConverter.convertToJST(NSDate()))))[indexPath.row].subject!.hexColor, alpha: 1)
            return cell
        } else {
            let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! InputViewSubjectListCell) ?? InputViewSubjectListCell()
            cell.subjectName.text = subjects![indexPath.row].name
            cell.backgroundColor = UIColor.hexStr(subjects![indexPath.row].hexColor, alpha: 1.0)
            return cell
        }
    }
    
    @IBAction func minusDeadlineUIButtonTouchUpInside(sender: AnyObject) {
        deadlineDatePicker.date = NSDate(timeInterval: -24*60*60, sinceDate: deadlineDatePicker.date)
    }
    
    @IBAction func plusDeadlineUIButtonTouchUpInside(sender: AnyObject) {
        deadlineDatePicker.date = NSDate(timeInterval: 24*60*60, sinceDate: deadlineDatePicker.date)
    }
    
    @IBAction func saveUIButtonTouchUpInside(sender: UIButton) {
        let homework = Homework()
        homework.subject? = subjects![subjectIndex!]
        homework.reference = reference!
        homework.closeAt = closeAt
        homework.createdAt = TimezoneConverter.convertToJST((NSDate()))
        if(update) {
            realm.update(self.homework, value: ["subject": homework.subject as! AnyObject, "reference": homework.reference, "closeAt": homework.closeAt])
        } else {
            realm.create(Homework.self, value: homework)
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelUIButtonTouchUpInside(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
