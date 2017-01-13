import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var toPhoto: UIButton!
    @IBOutlet weak var reference: UILabel!

    var sortOrder: SortOrder = .deadline
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    var delegate: ToPhotoDelegate?
    
    func setCell(homework :Homework) {
        var date: String?
        var sortName: String
        switch sortOrder {
        case .deadline: date = DateFormatter.stringFromDate(homework.createdAt)
            sortName = "入力日"
        case .createdAt: date = DateFormatter.stringFromDate(homework.closeAt)
            sortName = "締切日"
        }
        let formattedDate = date![date!.startIndex..<date!.endIndex.advancedBy(-6)]
        let cellBackgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.backgroundColor = cellBackgroundColor
        self.toPhoto.setTitle("\(sortName) \(formattedDate)", forState: .Normal)
        self.homework = homework
        toPhoto.setTitleColor(UIColor.blackColor(), forState: .Normal)
        changeCheckButton(homework)
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
        delegate?.deliverCreateAt(homework.createdAt)
    }
}
