import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var reference: UILabel!
 
    var homework = Homework()
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(homework :Homework) {
        self.close.text = DateFormatter.stringFromDate(homework.closeAt)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.backgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
    }
}

 
