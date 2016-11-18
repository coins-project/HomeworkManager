import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToPhotoDelegate  {
    
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
        let closeDate = String((keys)[section])
        let formattedCloseDate = closeDate[closeDate.startIndex..<closeDate.endIndex.advancedBy(-14)]
        return formattedCloseDate
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkDictionary[keys[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! TableViewCell
        let homework = homeworkDictionary[keys[indexPath.section]]![indexPath.row]
        cell.setCell(homework)
        cell.delegate = self
        return cell
    }
    
    func deliverCreateAt(createAt: NSDate) {
        if let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", createAt)) {
            let imageViewController = ImageViewController()
            let appearImage = UIImage(contentsOfFile: photo.url)
            let imageView = UIImageView(image: appearImage)
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.disappearImageView(_:))))
            self.view.addSubview(imageView)
        }
    }
    
    func disappearImageView(sender: UIGestureRecognizer) {
        sender.view!.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
        
        if alertController.popoverPresentationController != nil {
            alertController.popoverPresentationController!.sourceView = sender
            alertController.popoverPresentationController!.sourceRect = sender.bounds
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.presentViewController(alertController, animated: true, completion: {
                alertController.view.superview?.subviews[1].userInteractionEnabled = true
                alertController.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertView)))
            })
        }
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

protocol ToPhotoDelegate {
    func deliverCreateAt(createAt: NSDate)
}

