import UIKit
import RealmSwift

class ColorPanelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let realm = RealmModelManager.sharedManager
    private var subjects :Results<Subject>?
    @IBOutlet weak var colorPanel: UICollectionView!
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var colorView: UIView!
    
    var color = UIColor.grayColor()
    var hexColor: String = ""
    var deliverName: String? = ""
    let xCount = 15
    let yCount = 20
    var update: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(update) {
            self.subjectName.text = deliverName
            hexColor = (realm.findBy(Subject.self, filter: NSPredicate(format: "name == %@", deliverName!))?.hexColor)!
        }
        self.colorView.backgroundColor = UIColor.hexStr(hexColor, alpha: CGFloat(1.0))
        let layout = UICollectionViewFlowLayout()
        let width = colorPanel.bounds.width/(CGFloat(xCount)+0.3)
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        colorPanel.collectionViewLayout = layout
        colorPanel.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = colorPanel.dequeueReusableCellWithReuseIdentifier("color", forIndexPath: indexPath)
        cell.backgroundColor = colorFromPos(indexPath.section,  posS: indexPath.row)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return yCount
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xCount
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let color = colorFromPos(indexPath.section, posS: indexPath.row)
        
        self.hexColor = color.strHex()
        print(color.strHex())
        self.colorView.backgroundColor = color
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finished(sender: UIButton) {
        if(update) {
            let updateSubject = realm.findBy(Subject.self, filter: NSPredicate(format: "name == %@", deliverName!))
            let name = subjectName.text!
            let hexColor = self.hexColor
            realm.update(updateSubject!, value: ["name": name as AnyObject, "hexColor": hexColor as AnyObject])
        } else {
            let newSubject = Subject()
            newSubject.name = subjectName.text!
            newSubject.hexColor = self.hexColor
            realm.create(Subject.self, value: newSubject)
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
}
