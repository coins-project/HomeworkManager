import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var addButton: UIButton!
    private let realm = RealmModelManager.sharedManager
    private var homeworks: [Homework] = []
    private var closeDates: [NSDate] = []
    private var section = 0
    
    override func viewWillAppear(animated: Bool) {
        let today = TimezoneConverter.convertToJST(NSDate())
        for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
            if homework.closeAt.timeIntervalSinceDate(today) >= 0 {
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
        cell.subjectNameLabel.text = (homeworksOfToday[indexPath.row] as! Homework).subject!.name
        cell.referenceLabel.text = (homeworksOfToday[indexPath.row] as! Homework).reference
        cell.createdAt = (homeworksOfToday[indexPath.row] as! Homework).createdAt
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let createdAt = (collectionView.cellForItemAtIndexPath(indexPath) as! ListCollectionViewCell).createdAt
        if realm.findAllObjects(Photo).count != 0 {
            let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", createdAt))
        }
    }
    
    @IBAction func tapAddButton(sender: UIButton) {
        let alertController = UIAlertController(title: "新規作成", message: "選択してください", preferredStyle: .ActionSheet)
        let startCameraAction = UIAlertAction(title: "カメラ起動", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.startCamera() })
        let editItemAction = UIAlertAction(title: "課題入力", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.editItem() })
        
        alertController.addAction(startCameraAction)
        alertController.addAction(editItemAction)
        
        if alertController.popoverPresentationController != nil {
            alertController.popoverPresentationController!.sourceView = sender
            alertController.popoverPresentationController!.sourceRect = sender.bounds
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
 
    func startCamera() {
        let myCameraViewController = CameraViewController()
        myCameraViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(myCameraViewController as UIViewController, animated: true, completion: nil)
        myCameraViewController.pickImageFromCamera()
    }

    func editItem() {
        let inputScreenStoryboard = UIStoryboard(name: "Input", bundle: nil)
        let inputTableViewController = inputScreenStoryboard.instantiateViewControllerWithIdentifier("InputScreen") as! InputTableViewController
        self.presentViewController(inputTableViewController, animated: true, completion: nil)
    }
}
