import UIKit

class ColorPanelViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var colorPanel: UICollectionView!
    
    let xCount = 15
    let yCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
//    {
//        //コレクションビューから識別子「TestCell」のセルを取得する。
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("color", forIndexPath: indexPath) as UICollectionViewCell
//        
//        //セルの背景色をランダムに設定する。
//        cell.backgroundColor = UIColor(red: CGFloat(drand48()),
//                                       green: CGFloat(drand48()),
//                                       blue: CGFloat(drand48()),
//                                       alpha: 1.0)
//        return cell
//    }
    
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

    var blockSize: CGSize! = nil
    var size: CGSize! = nil

    func colorFromPoint(point: CGPoint) -> UIColor {
        let posX = Int(point.x * CGFloat(xCount) / size.width)
        let posY = Int(point.y * CGFloat(yCount) / size.height)
        return colorFromPos(posY, posS: posX)
    }
    
    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        // 白〜黒のやつ
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
}
