//
//  PhotoMessage.swift
//  Anchor
//
//  Created by Helen Cao on 8/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController

class PhotoMessage: Message {
    
    // MARK: - Properties
    

    var downloadURl: URL?
    var photoContent: JSQPhotoMediaItem?
    
    override var dictValue: [String : Any] {
        let userDict = ["username" : sender.username,
                        "uid" : sender.uid]
        
        return ["sender" : userDict,
                "contentURL" : "\(downloadURl!)",
                "timestamp" : timestamp.timeIntervalSince1970,
                "isPhoto": true]
    }
    
    lazy var jsqPhotoMessageValue: JSQMessage = {
        return JSQMessage(senderId: self.sender.uid,
                          senderDisplayName: self.sender.username,
                          date: self.timestamp,
                          media: self.photoContent)
    }()
    // MARK: - Init
    
    override init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["downloadURL"] as? String
            else { return nil }

        self.downloadURl = URL(string: content)!
        
        
        
        super.init(snapshot: snapshot)
//        self.key = snapshot.key
//        self.content = content
//        self.timestamp = Date(timeIntervalSince1970: timestamp)
//        self.sender = User(uid: uid, username: username)
        
        
        
        
        

    }
    
    init(content: UIImage, downloadURL: URL) {
        self.photoContent = JSQPhotoMediaItem(image: content)
        self.downloadURl = downloadURL
        super.init(content: "")
        self.isPhoto = true
        
        
        // should be in a service but its good for now
    }
    
    
    
    
}
