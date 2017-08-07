//
//  FriendCell.swift
//  Anchor
//
//  Created by Helen Cao on 8/1/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    var completionHandler: ((UITableViewCell) -> Void)?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    @IBAction func chatButtonTapped(_ sender: UIButton) {
        completionHandler?(self)
    }

}
