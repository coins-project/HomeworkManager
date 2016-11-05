import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var reference: UILabel!
    
    var homework = Homework()
    
    func setCell(homework :Homework) {
        self.close.text = DateFormatter.stringFromDate(homework.closeAt)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.check.setImage(UIImage(named: "checked.png"), forState: UIControlState.Selected)
        self.check.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        self.backgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
    }
    
    internal func tapCheckButton(sender: UIButton){
        check.selected = !check.selected
    }
}
