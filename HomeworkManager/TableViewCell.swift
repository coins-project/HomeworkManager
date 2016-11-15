import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var reference: UILabel!
    
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    
    //let cell = check.superview as!
    
    //http://qiita.com/mzuk/items/0efc41460631c7c98c3c
    
    func setCell(homework :Homework) {
        self.close.text = DateFormatter.stringFromDate(homework.closeAt)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        if(homework.finished) {
            self.check.setImage(UIImage(named: "checked.png"), forState: UIControlState.Selected)
        } else {
            self.check.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        }
        self.backgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.homework = homework
    }
    
    internal func tapCheckButton(sender: UIButton){
        check.selected = !check.selected
        
        homework.finished = !homework.finished
        //ここでトランザクションが走る
        realm.update(homework)
        
        
//        self.superview!.superview.reloadData()
        
        print(homework.subject?.name)
        print(homework.finished)
    }
    
    
    
}
