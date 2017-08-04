//
//  UserInfoTableViewCell.swift
//  Anchor
//
//  Created by Helen Cao on 7/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ChatListViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
 
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
