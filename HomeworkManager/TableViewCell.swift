import UIKit
import Realm

class TableViewCell: UITableViewCell {

    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var toPhoto: UIButton!
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var createAt: UILabel!
    
    var homework = Homework()
    var realm = RealmModelManager.sharedManager
    
    func setCell(homework :Homework) {
        let createDate = DateFormatter.stringFromDate(homework.createdAt)
        let formattedCreateDate = createDate[createDate.startIndex..<createDate.endIndex.advancedBy(-6)]
        createAt.text = formattedCreateDate

        if (homework.photo != nil) {
            self.toPhoto.setTitleColor(UIColor(white: 0, alpha: 0.6), forState: .Normal)
        }
        else {
            self.toPhoto.alpha =  0
            self.toPhoto.enabled = false
        }
        
        let cellBackgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.check.addTarget(self, action: #selector(TableViewCell.tapCheckButton(_:)), forControlEvents: .TouchUpInside)
        self.backgroundColor = cellBackgroundColor
        
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
            self.check.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
        } else {
            self.check.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func tapToPhoto(sender: UIButton) {
        self.displayPhoto(homework.createdAt)
    }
    
    func displayPhoto(date: NSDate) {
        if let photo = realm.findBy(Photo.self, filter: NSPredicate(format: "createdAt == %@", date)) {
            //self.photo = photo
            let appearImage = UIImage(contentsOfFile: photo.url)
            let imageView = UIImageView(image: appearImage)
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.disappearImageView(_:))))
                ViewController().view.addSubview(imageView)
        }
    }
    
    func disappearImageView(sender: UIGestureRecognizer) {
        sender.view!.removeFromSuperview()
    }
    
}
