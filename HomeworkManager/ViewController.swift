import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var addButton: UIButton!
    
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
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ListCollectionViewCell) ?? ListCollectionViewCell()
        return cell
    }
    
    
    @IBAction func tapAddButton(sender: UIButton) {
        let alertController = UIAlertController(title: "新規作成", message: "選択してください", preferredStyle: .ActionSheet)
        let startCameraAction = UIAlertAction(title: "カメラ起動", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.startCamera() })
        let editItemAction = UIAlertAction(title: "課題入力", style: .Default,
                handler:{(action:UIAlertAction!) -> Void in self.editItem() })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
                action in print("pushed cancel") }
        
        alertController.addAction(startCameraAction)
        alertController.addAction(editItemAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            alertController.popoverPresentationController?.sourceView = sender as UIView;
            alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)        }
        self.presentViewController(alertController, animated: true, completion: nil)
        }//ポップバーじゃない?
 
    func startCamera() {
        print("start camera")
        let myCameraViewController = CameraViewController()
        myCameraViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(myCameraViewController as UIViewController, animated: true, completion: nil)
        myCameraViewController.pickImageFromCamera()
    }

    func editItem() {
        print("edit item")
        let myInputTableViewController: UITableViewController = InputTableViewController()
        myInputTableViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(myInputTableViewController, animated: true, completion: nil)
    }
}

