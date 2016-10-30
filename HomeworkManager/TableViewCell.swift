//
//  TableViewCell.swift
//  HomeworkManager
//
//  Created by 古川 和輝 on 2016/10/30.
//  Copyright © 2016年 takayuki abe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var subject: UILabel!
    
    var homework = Homework()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(homework :Homework) {
        self.close.text = DateFormatter.stringFromDate(homework.closeAt)
        self.reference.text = homework.reference
        self.subject.text = homework.subject?.name
        self.backgroundColor = UIColor.hexStr(homework.subject!.hexColor, alpha: 1)
    }

}
