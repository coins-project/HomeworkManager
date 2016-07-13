import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
}
