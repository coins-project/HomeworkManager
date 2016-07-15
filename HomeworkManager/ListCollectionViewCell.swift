import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    var createdAt: NSDate = NSDate()
    var closeAt: NSDate = NSDate()
    var homework = Homework()
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
}
