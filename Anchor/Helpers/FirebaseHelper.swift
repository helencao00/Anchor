//
//  FirebaseHelper.swift
//  Anchor
//
//  Created by Helen Cao on 8/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FirebaseHelper {
    let dataReference = Database.database().reference().child("chat")
}
