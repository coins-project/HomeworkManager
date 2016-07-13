import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var SubjectNameLabel: UILabel!

    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
}
