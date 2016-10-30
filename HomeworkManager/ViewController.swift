import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let realm = RealmModelManager.sharedManager
    private var homeworkDictionary: Dictionary = [NSDate: [Homework]]()
    private var keys = [NSDate]()
    private var photo = Photo()
    override func viewWillAppear(animated: Bool) {
        let today = TimezoneConverter.convertToJST(NSDate())
        homeworkDictionary = [:]
        for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
            if homework.closeAt.timeIntervalSinceDate(today) >= 0 {
                if homeworkDictionary[homework.closeAt] == nil {
                    homeworkDictionary[homework.closeAt] = [homework]
                }else {
                    homeworkDictionary[homework.closeAt]?.append(homework)
                }
                print("time = \(homework.closeAt)")
                print("")
            }
        }
        
        keys = Array(homeworkDictionary.keys)
        keys.sortInPlace({ $0.compare($1) == NSComparisonResult.OrderedAscending })
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
        cell.homeworkCollectionView.reloadData()
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String((keys)[section])
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tableViewCell = (collectionView.superview?.superview as! ListTableViewCell)
        let tableView = (collectionView.superview?.superview?.superview?.superview) as! UITableView
        let section = tableView.indexPathForCell(tableViewCell)?.section
        let key = keys[section!]
        let homework = homeworkDictionary[key]!
        print("numberOfItems in \(section) : \(homework.count)")
        return homework.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tableViewCell = (collectionView.superview?.superview as! ListTableViewCell)
        let tableView = (collectionView.superview?.superview?.superview?.superview) as! UITableView
        let section = tableView.indexPathForCell(tableViewCell)?.section
        let key = keys[section!]
        print("key = \(key)")
        print(homeworkDictionary[key])
        let homework = homeworkDictionary[key]![indexPath.row]
        print("key = \(key)")
        print("homework = \(homework)")
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ListCollectionViewCell) ?? ListCollectionViewCell()
        cell.homework = homework
        cell.subjectNameLabel.text = homework.subject!.name
        cell.referenceLabel.text = homework.reference
        cell.createdAt = homework.createdAt
        cell.closeAt = key
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapHomework(_:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.pressLongHomework(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.addGestureRecognizer(longGesture)
        let subjectColor = UIColor.hexStr(cell.homework.subject!.hexColor, alpha: 1)
        cell.backgroundColor = subjectColor
        cell.alpha = homework.finished ? 0.5 : 1.0
        
        
        return cell
    }
    
    func tapHomework(sender: UIGestureRecognizer) {
        let homework = (sender.view as! ListCollectionViewCell).homework
        if let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", homework.createdAt)) {
            self.photo = photo
            let imageViewController = ImageViewController()
            let appearImage = UIImage(contentsOfFile: photo.url)
            let imageView = UIImageView(image: appearImage)
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "disappearImageView:"))
            self.view.addSubview(imageView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let imageViewController: ImageViewController = segue.destinationViewController as! ImageViewController
        imageViewController.image = self.photo
    }
    
    func pressLongHomework(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            let homework = (sender.view as! ListCollectionViewCell).homework
            try! realm.realm.write { homework.finished = !homework.finished }
            tableView.reloadData()
        }
    }
    
    func disappearImageView(sender: UIGestureRecognizer) {
        sender.view!.removeFromSuperview()
    }
    
    @IBAction func tapAddButton(sender: UIButton) {
        let alertController = UIAlertController(title: "新規作成", message: "選択してください", preferredStyle: .ActionSheet)
        let startCameraAction = UIAlertAction(title: "カメラ起動", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.startCamera() })
        let pickImageFromLibraryAction = UIAlertAction(title: "カメラロールから選択", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.pickImageFromLibrary() })
        let editItemAction = UIAlertAction(title: "課題入力", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.editItem() })
        
        alertController.addAction(startCameraAction)
        alertController.addAction(pickImageFromLibraryAction)
        alertController.addAction(editItemAction)

        print(alertController)
        print(alertController.popoverPresentationController)
        
        if alertController.popoverPresentationController != nil {
            alertController.popoverPresentationController!.sourceView = sender
            alertController.popoverPresentationController!.sourceRect = sender.bounds
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
 
    func startCamera() {
        let myCameraViewController = CameraViewController()
        myCameraViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(myCameraViewController as UIViewController, animated: true, completion: nil)
        myCameraViewController.pickImageFromCamera()
    }
    
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func editItem() {
        let inputScreenStoryboard = UIStoryboard(name: "Input", bundle: nil)
        let inputTableViewController = inputScreenStoryboard.instantiateViewControllerWithIdentifier("InputScreen") as! InputTableViewController
        self.presentViewController(inputTableViewController, animated: true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.PortraitUpsideDown
    }
    
}
