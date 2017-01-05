import UIKit
import RealmSwift

class ColorPanelViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var colorPanel: UICollectionView!
    
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
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let testCell = collectionView.cellForItemAtIndexPath(indexPath) as! TestCollectionViewCell
//        let resultIndex = indexPath.row % 4
//        
//        //セルの中のラベルの値を変更する。
//        testCell.testLabel.text = member[resultIndex]
//    colorFromPos(indexPath.section,  posS: indexPath.row)
//}

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
