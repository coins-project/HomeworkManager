import UIKit
import RealmSwift

class ColorPanelViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private let realm = RealmModelManager.sharedManager
    private var subjects :Results<Subject>?
    var subject = Subject() //よくわからない
    @IBOutlet weak var colorPanel: UICollectionView!
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var colorView: UIView!

    var color = UIColor.grayColor()
    var hexColor = ""
    let xCount = 15
    let yCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let width = colorPanel.bounds.width/(CGFloat(xCount)+0.3)
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        colorPanel.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        color = colorFromPos(indexPath.section, posS: indexPath.row)
        colorView.backgroundColor = color
    }

    @IBAction func finished(sender: UIButton) {
        let newSubject = Subject()
        newSubject.name = subjectName.text!//空白のときは？
        newSubject.hexColor = self.color.strHex()
        if(newSubject.name != "") {
            realm.update(self.subject, value: ["name": newSubject.name as AnyObject, "hexColor": newSubject.hexColor as AnyObject]) //よくわからない
        } else {
            realm.create(Subject.self, value: subjects!)
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    var blockSize: CGSize! = nil
    var size: CGSize! = nil

    func colorFromPoint(point: CGPoint) -> UIColor {
        let posX = Int(point.x * CGFloat(xCount) / size.width)
        let posY = Int(point.y * CGFloat(yCount) / size.height)
        return colorFromPos(posY, posS: posX)
    }
    
    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
}
