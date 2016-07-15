import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var addButton: UIButton!
    private let realm = RealmModelManager.sharedManager
    private var homeworkDictionary: Dictionary = [NSDate: [Homework]]()
    private var homeworks: [Homework] = []
    private var closeDates: [NSDate] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let today = TimezoneConverter.convertToJST(NSDate())
        for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
            if homework.closeAt.timeIntervalSinceDate(today) >= 0 {
                if homeworkDictionary[homework.closeAt] == nil {
                    homeworkDictionary[homework.closeAt] = [homework]
                }else {
                    homeworkDictionary[homework.closeAt]?.append(homework)
                }
                print("Dictonary = \(homeworkDictionary)")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return homeworkDictionary.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier("cell")! as! ListTableViewCell) ?? ListTableViewCell()
        //cell.homeworkCollectionView.reloadData()
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(Array(homeworkDictionary.keys)[section])
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tableViewCell = (collectionView.superview?.superview as! ListTableViewCell)
        let tableView = (collectionView.superview?.superview?.superview?.superview) as! UITableView
        let section = tableView.indexPathForCell(tableViewCell)?.section
        let key = Array(homeworkDictionary.keys)[section!]
        let homework = homeworkDictionary[key]!
        print("numberOfItems in \(section) : \(homework.count)")
        return homework.count
//        return homeworkDictionary[key]![section].count
//        print("self.section = \(self.section)")
//        print("closeDates = \(closeDates)")
//        self.section = (self.section + 1) % (closeDates.count)
//        print("numberOfItems \((homeworks as NSArray).filteredArrayUsingPredicate(NSPredicate(format: "closeAt == %@", closeDates[self.section])).count)")
  //      return (homeworks as NSArray).filteredArrayUsingPredicate(NSPredicate(format: "closeAt == %@", closeDates[self.section])).count
//        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tableViewCell = (collectionView.superview?.superview as! ListTableViewCell)
        let tableView = (collectionView.superview?.superview?.superview?.superview) as! UITableView
        let section = tableView.indexPathForCell(tableViewCell)?.section
        let key = Array(homeworkDictionary.keys)[section!]
        let homework = homeworkDictionary[key]![indexPath.row]
        print(key)
        print(homework)
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ListCollectionViewCell) ?? ListCollectionViewCell()
        cell.homework = homework
        cell.subjectNameLabel.text = homework.subject!.name
        cell.referenceLabel.text = homework.reference
        cell.createdAt = homework.createdAt
        cell.closeAt = key
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHomework:")
        let longGesture = UILongPressGestureRecognizer(target: self, action: "pressLongHomework:")
        cell.addGestureRecognizer(tapGesture)
        cell.addGestureRecognizer(longGesture)
        
        cell.alpha = homework.finished ? 0.5 : 1.0
        
        return cell
    }
    
    func tapHomework(sender: UIGestureRecognizer) {
        let homework = (sender.view as! ListCollectionViewCell).homework
        if let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", homework.createdAt)) {
            let appearImage = UIImage(contentsOfFile: photo.url)
            let imageView = UIImageView(image: appearImage)
            self.view.addSubview(imageView)
        }
    }
    
    func pressLongHomework(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            let homework = (sender.view as! ListCollectionViewCell).homework
            try! realm.realm.write { homework.finished = !homework.finished }
            tableView.reloadData()
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
