//
//  ActivityTableViewCell.swift
//  Deadliner
//
//  Created by Muhammad Iksanul on 09/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameActivity: UILabel!
    @IBOutlet weak var priorityActivity: UILabel!{
        didSet{
            priorityActivity.layer.cornerRadius = 5
            priorityActivity.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var timerActivity: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
