import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var reference: UILabel!
    
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    
    func setCell(homework :Homework) {
        self.close.text = DateFormatter.stringFromDate(homework.closeAt)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.backgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.homework = homework
        changeCheckButton(homework)
    }
    
    func tapCheckButton(sender: UIButton){
        check.selected = !check.selected
        realm.update(homework, value: ["finished": check.selected])
        changeCheckButton(homework)
        print(homework.subject?.name)
        print(homework.finished)
    }
    
    func changeCheckButton(homework: Homework) {
        if(homework.finished) {
            self.check.setImage(UIImage(named: "checked.png"), forState: UIControlState.Selected)
        } else {
            self.check.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        }
    }
    
    
}
