import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var reference: UILabel!
    
    @IBOutlet weak var customCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(homework :Homework) {
        self.subject.text = homework.subject?.name
        let dateString = DateFormatter.stringFromDate(homework.closeAt)
        self.close.text = dateString
        self.reference.text = homework.reference
        let subjectColor = UIColor.hexStr((homework.subject?.hexColor)!, alpha: 1)
        self.customCell.backgroundColor = subjectColor
        print(subjectColor)
    }
}

