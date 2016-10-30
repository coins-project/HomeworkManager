import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private let realm = RealmModelManager.sharedManager
    private var homeworkDictionary: Dictionary = [NSDate: [Homework]]()
    private var keys = [NSDate]()
    private var photo = Photo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let today = TimezoneConverter.convertToJST(NSDate())
        homeworkDictionary = [:]
        for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
            if homework.closeAt.timeIntervalSinceDate(today) >= 0 {
                if homeworkDictionary[homework.closeAt] == nil {
                    homeworkDictionary[homework.closeAt] = [homework]
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }else {
                    homeworkDictionary[homework.closeAt]?.append(homework)
                }
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String((keys)[section])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkDictionary[keys[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomTableViewCell
        let homework = homeworkDictionary[keys[indexPath.section]]![indexPath.row]
        cell.setCell(homework)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomTableViewCell
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHomework:")
        let longGesture = UILongPressGestureRecognizer(target: self, action: "pressLongHomework:")
        cell.addGestureRecognizer(tapGesture)
        cell.addGestureRecognizer(longGesture)
    }
    
    func tapHomework(sender: UIGestureRecognizer) {
        let homework = (sender.view as! CustomTableViewCell).homework
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
            let homework = (sender.view as! CustomTableViewCell).homework
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
                handler:{(action:UIAlertAction!) -> Void in self.startImagePicker() })
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
    
    func startImagePicker() {
        let myCameraViewController = CameraViewController()
        myCameraViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(myCameraViewController as UIViewController, animated: true, completion: nil)
        myCameraViewController.pickImageFromLibrary()
    }

    func editItem() {
        let inputScreenStoryboard = UIStoryboard(name: "Input", bundle: nil)
        let inputTableViewController = inputScreenStoryboard.instantiateViewControllerWithIdentifier("InputScreen") as! InputTableViewController
        self.presentViewController(inputTableViewController, animated: true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.PortraitUpsideDown
    }
    
}
