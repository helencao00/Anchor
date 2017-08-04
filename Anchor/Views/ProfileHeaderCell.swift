//
//  ProfileHeaderCell.swift
//  Anchor
//
//  Created by Helen Cao on 8/4/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

protocol ProfileHeaderCellDelegate: class {
    func didTapLogoutButton(_ button: UIButton, on headerView: ProfileHeaderCell)
}

class ProfileHeaderCell: UICollectionReusableView {
    weak var delegate: ProfileHeaderCellDelegate?
    
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
        settingsButton.layer.borderWidth = 1
    }
    @IBAction func LogoutButtonTapped(_ sender: UIButton) {
        delegate?.didTapLogoutButton(sender, on: self)
    }
    
    
    
}
