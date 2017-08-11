//
//  FindFriendsCell.swift
//  Anchor
//
//  Created by Helen Cao on 7/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell)
}
class FindFriendsCell: UITableViewCell {
//    var isSelected
    var user: User?
    weak var delegate: FindFriendsCellDelegate?
    
    var tapAction: ((UITableViewCell) -> Void)?

    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addFriendButton.setTitle("Add Friend", for: .normal)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    @IBAction func addFriendButtonTapped(_ sender: UIButton) {

        //delegate?.didTapFollowButton(sender, on: self)
        
        tapAction?(self)
    }

}
