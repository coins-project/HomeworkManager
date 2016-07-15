import UIKit

class TodayHomeworkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
}
