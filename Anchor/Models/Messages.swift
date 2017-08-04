//
//  Messages.swift
//  Anchor
//
//  Created by Helen Cao on 7/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import JSQMessagesViewController

class Message {
    
    // MARK: - Properties
    
    var key: String?
    let content: String
    let timestamp: Date
    let sender: User
    var isPhoto: Bool
    
    var dictValue: [String : Any] {
        let userDict = ["username" : sender.username,
                        "uid" : sender.uid]
        
        return ["sender" : userDict,
                "content" : content,
                "timestamp" : timestamp.timeIntervalSince1970,
                "isPhoto": false]
    }
    
    lazy var jsqMessageValue: JSQMessage = {
        return JSQMessage(senderId: self.sender.uid,
                          senderDisplayName: self.sender.username,
                          date: self.timestamp,
                          text: self.content)
    }()
    // MARK: - Init
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String,
            let isPhoto = dict["isPhoto"] as? Bool
            else { return nil }
        self.isPhoto = isPhoto
        self.key = snapshot.key
        self.content = content
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.sender = User(uid: uid, username: username)
    }
    
    init(content: String) {
        self.isPhoto = false
        self.content = content
        self.timestamp = Date()
        self.sender = User.current
    }
    
}
