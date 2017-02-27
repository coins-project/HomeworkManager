import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var toPhoto: UIButton!
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    var delegate: ToPhotoDelegate?
    
    func setCell(homework :Homework) {
        let createDate = DateFormatter.stringFromDate(homework.createdAt)
        let formattedCreateDate = createDate[createDate.startIndex..<createDate.endIndex.advancedBy(-6)]
        let cellBackgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.backgroundColor = cellBackgroundColor
        self.date.text = formattedCreateDate
        self.homework = homework
        changeCheckButton(homework)
    }

    func tapCheckButton(sender: UIButton){
        check.selected = !check.selected
        realm.update(homework, value: ["finished": check.selected])
        changeCheckButton(homework)
    }
    
    func changeCheckButton(homework: Homework) {
        if(homework.finished) {
            self.checkImage.image = UIImage(named: "checked.png")
        } else {
            self.checkImage.image = UIImage(named: "unchecked.png")
        }
    }
    
    @IBAction func tapToPhoto(sender: UIButton) {
        delegate?.deliverCreateAt(homework.createdAt)
    }
}
