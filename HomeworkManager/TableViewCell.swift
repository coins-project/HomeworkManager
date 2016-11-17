import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var toPhoto: UIButton!
    @IBOutlet weak var reference: UILabel!
    
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    
    func setCell(homework :Homework) {
        let createDate = DateFormatter.stringFromDate(homework.createdAt)
        let formattedCreateDate = createDate[createDate.startIndex..<createDate.endIndex.advancedBy(-6)]
        
        let buttonBackgroundColor = UIColor(white: 1, alpha: 0.4)
        let backgroundImage = self.createColorImage(buttonBackgroundColor)
        self.toPhoto.setBackgroundImage(backgroundImage, forState: .Normal)
        
        self.toPhoto.setTitle(formattedCreateDate, forState: .Disabled)
        if (homework.photo != nil) {
            self.toPhoto.setTitle(formattedCreateDate, forState: .Normal)
            print(formattedCreateDate)
            self.toPhoto.setTitleColor(UIColor(white: 0, alpha: 1), forState: .Normal)
            self.toPhoto.enabled = false
        }
        else {
            self.toPhoto.setTitle(formattedCreateDate, forState: .Disabled)
            print(formattedCreateDate)
            self.toPhoto.setTitleColor(UIColor(white: 0, alpha: 0.5), forState: .Disabled)
        }
        
        let cellBackgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.backgroundColor = cellBackgroundColor
        
        self.homework = homework
        changeCheckButton(homework)
    }
    
    private func createColorImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    
    func tapCheckButton(sender: UIButton){
        check.selected = !check.selected
        realm.update(homework, value: ["finished": check.selected])
        changeCheckButton(homework)
    }
    
    func changeCheckButton(homework: Homework) {
        if(homework.finished) {
            self.check.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
        } else {
            self.check.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func tapToPhoto(sender: UIButton) {
        
        
    }
    
}
