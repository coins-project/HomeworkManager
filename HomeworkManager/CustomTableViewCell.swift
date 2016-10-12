import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Close: UILabel!
    @IBOutlet weak var Subject: UILabel!
    @IBOutlet weak var Reference: UILabel!

    var homework = Homework()
    
    
    override func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
}
