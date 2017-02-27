import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToPhotoDelegate  {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIButton!


    private let realm = RealmModelManager.sharedManager
    private var homeworkDictionary: Dictionary = [NSDate: [Homework]]()
    private var keys = [NSDate]()
    private var photo = Photo()
    private var sortOrder: SortOrder = .deadline
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        loadDictionary()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func loadDictionary() {
        homeworkDictionary = [:]
        switch sortOrder {
        case .deadline:
            for homework in realm.findAllObjects(Homework.self).sorted("closeAt", ascending: true) {
                if homeworkDictionary[homework.closeAt] == nil {
                    homeworkDictionary[homework.closeAt] = [homework]
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }else {
                    homeworkDictionary[homework.closeAt]?.append(homework)
                }
            }
        case .createdAt:
            for homework in realm.findAllObjects(Homework.self).sorted("createdAt", ascending: true) {
                if homeworkDictionary[homework.createdAt] == nil {
                    homeworkDictionary[homework.createdAt] = [homework]
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }else {
                    homeworkDictionary[homework.createdAt]?.append(homework)
                }
            }
        }
        keys = Array(homeworkDictionary.keys)
        keys.sortInPlace({ $0.compare($1) == NSComparisonResult.OrderedAscending })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return homeworkDictionary.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = String(keys[section])
        let formattedDate = date[date.startIndex..<date.endIndex.advancedBy(-14)]
        return "\(sortOrder.rawValue[sortOrder.rawValue.startIndex..<sortOrder.rawValue.endIndex.advancedBy(-1)]) \(formattedDate)"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkDictionary[keys[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! TableViewCell
        let homework = homeworkDictionary[keys[indexPath.section]]![indexPath.row]
        cell.setCell(homework)
        cell.sortOrder = sortOrder
        cell.delegate = self
        return cell
    }
    
    func deliverCreateAt(createAt: NSDate) {
        displayPhoto(createAt)
    }
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            realm.delete(cell.homework)
            loadDictionary()
            self.tableView.reloadData()
        default:
            return
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let inputScreen: UIStoryboard = UIStoryboard(name: "Input", bundle: nil)
        let inputView: InputTableViewController = inputScreen.instantiateInitialViewController() as! InputTableViewController
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
        inputView.homework = cell.homework
        self.presentViewController(inputView, animated: true, completion: nil)
    }
    
    @IBAction func sortButtonDidTap(sender: UIButton) {
        switch sortOrder {
        case .deadline: sortOrder = .createdAt
        case .createdAt: sortOrder = .deadline
        }
        sortButton.setTitle(sortOrder.rawValue, forState: .Normal)
        loadDictionary()
        self.tableView.reloadData()
    }
    
    @IBAction func cameraButtonDidTap(sender: UIBarButtonItem) {
        let today = TimezoneConverter.convertToJST(NSDate())
        let alertController = UIAlertController(title: "選択してください", message: "", preferredStyle: .ActionSheet)
        let displayPhotoAction = UIAlertAction(title: "今日の写真を表示", style: .Default, handler:{(action:UIAlertAction!) -> Void in self.displayPhoto(today) })
        let startCameraAction = UIAlertAction(title: "カメラ起動", style: .Default,
                                              handler:{(action:UIAlertAction!) -> Void in self.startCamera() })
        let pickImageFromLibraryAction = UIAlertAction(title: "カメラロールから選択", style: .Default, handler:{(action:UIAlertAction!) -> Void in self.startImagePicker() })
        
        alertController.addAction(displayPhotoAction)
        alertController.addAction(startCameraAction)
        alertController.addAction(pickImageFromLibraryAction)
        
        alertController.popoverPresentationController!.sourceView = view
        alertController.popoverPresentationController!.sourceRect = CGRect(x: 25, y: 50, width: 10, height: 10)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func tapHomework(sender: UIGestureRecognizer) {
        let homework = (sender.view as! TableViewCell).homework
        displayPhoto(homework.createdAt)
    }
    
    func displayPhoto(date: NSDate) {
        if let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", date)) {
            cameraButton.enabled = false
            self.photo = photo
            let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let photoUrl = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("images")?.URLByAppendingPathComponent((photo.url as NSString).lastPathComponent)
            let appearImage = UIImage(contentsOfFile: photoUrl!.path!)
            let imageView = UIImageView(image: appearImage)
            imageView.frame = calcImageFrame()
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.disappearImageView(_:))))
            self.view.addSubview(imageView)
            self.tableView.reloadData()
        }
    }
    
    func calcImageFrame() -> CGRect {
        let navigationBarFrame = self.navigationController!.navigationBar.frame
        var imageFrame = tableView.subviews[0].frame
        imageFrame.origin.y = navigationBarFrame.size.height + navigationBarFrame.origin.y
        return imageFrame
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let imageViewController: ImageViewController = segue.destinationViewController as! ImageViewController
        imageViewController.image = self.photo
    }
    
    func pressLongHomework(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            let homework = (sender.view as! TableViewCell).homework
            try! realm.realm.write { homework.finished = !homework.finished }
            tableView.reloadData()
        }
    }
    
    func disappearImageView(sender: UIGestureRecognizer) {
        sender.view!.removeFromSuperview()
        cameraButton.enabled = true
    }

    @IBAction func settingButton(sender: UIBarButtonItem) {
        let colorPanelStoryboard = UIStoryboard(name: "ColorPanel", bundle: nil)
        let colorPanelViewController = colorPanelStoryboard.instantiateViewControllerWithIdentifier("Subject") as! EditSubjectViewController
        self.presentViewController(colorPanelViewController, animated: true, completion: nil)
    }

    @IBAction func tapAddButton(sender: UIButton) {
        editItem()
    }
    
    func dismissAlertView() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
