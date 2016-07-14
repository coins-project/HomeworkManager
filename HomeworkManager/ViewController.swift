import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let realm = RealmModelManager.sharedManager
    private var homeworks: [Homework] = []
    private var closeDates: [NSDate] = []
    private var section = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
        let today = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()))
        for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
            if homework.closeAt.timeIntervalSinceDate(today!) > 0 {
                homeworks.append(homework)
            }
        }
        self.section = 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        for homework in homeworks {
            if closeDates.indexOf(homework.closeAt) == nil {
                closeDates.append(homework.closeAt)
            }
        }
        return closeDates.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.section = indexPath.section
        let cell = (tableView.dequeueReusableCellWithIdentifier("cell")! as! ListTableViewCell) ?? ListTableViewCell()
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(closeDates[section])
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section = (self.section + 1) % (closeDates.count)
        return (homeworks as NSArray).filteredArrayUsingPredicate(NSPredicate(format: "closeAt == %@", closeDates[self.section])).count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ListCollectionViewCell) ?? ListCollectionViewCell()
        let homeworksOfToday = (homeworks as NSArray).filteredArrayUsingPredicate(NSPredicate(format: "closeAt == %@", closeDates[self.section]))
        cell.subjectNameLabel.text = (homeworksOfToday[indexPath.row] as! Homework).subjects[0].name
        cell.referenceLabel.text = (homeworksOfToday[indexPath.row] as! Homework).reference
        cell.createdAt = (homeworksOfToday[indexPath.row] as! Homework).createdAt
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let createdAt = (collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell).createdAt
    }
}

