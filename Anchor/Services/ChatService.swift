//
//  ChatService.swift
//  Anchor
//
//  Created by Helen Cao on 7/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import JSQMessagesViewController
import JSQSystemSoundPlayer

struct ChatService{
    static func create(from message: Message, with chat: Chat, completion: @escaping (Chat?) -> Void) {
        
        var membersDict = [String : Bool]()
        for uid in chat.memberUIDs {
            membersDict[uid] = true
        }
        
        
        let lastMessage = "\(message.sender.username): \(message.content)"
        chat.lastMessage = lastMessage
        let lastMessageSent = message.timestamp.timeIntervalSince1970
        chat.lastMessageSent = message.timestamp
        
        
        let chatDict: [String : Any] = ["title" : chat.title,
                                        "memberHash" : chat.memberHash,
                                        "members" : membersDict,
                                        "lastMessage" : lastMessage,
                                        "lastMessageSent" : lastMessageSent]
        
        
        let chatRef = Database.database().reference().child("chats").child(User.current.uid).childByAutoId()
        chat.key = chatRef.key
        
        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            multiUpdateValue["chats/\(uid)/\(chatRef.key)"] = chatDict
        }
        
        
        let messagesRef = Database.database().reference().child("messages").child(chatRef.key).childByAutoId()
        let messageKey = messagesRef.key
        
        
        multiUpdateValue["messages/\(chatRef.key)/\(messageKey)"] = message.dictValue
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            completion(chat)
        }
    }
    static func create(from message: PhotoMessage, with chat: Chat, completion: @escaping (Chat?) -> Void) {
        
        var membersDict = [String : Bool]()
        for uid in chat.memberUIDs {
            membersDict[uid] = true
        }
        
        //        let lastMessage = "\(message.sender.username): \(message.downloadURl!)"
        let lastMessage = "Image"
        chat.lastMessage = lastMessage
        let lastMessageSent = message.timestamp.timeIntervalSince1970
        chat.lastMessageSent = message.timestamp
        
        
        let chatDict: [String : Any] = ["title" : chat.title,
                                        "memberHash" : chat.memberHash,
                                        "members" : membersDict,
                                        "lastMessage" : lastMessage,
                                        "lastMessageSent" : lastMessageSent]
        
        
        let chatRef = Database.database().reference().child("chats").child(User.current.uid).childByAutoId()
        chat.key = chatRef.key
        
        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            multiUpdateValue["chats/\(uid)/\(chatRef.key)"] = chatDict
        }
        
        
        let messagesRef = Database.database().reference().child("messages").child(chatRef.key).childByAutoId()
        let messageKey = messagesRef.key
        
        
        multiUpdateValue["messages/\(chatRef.key)/\(messageKey)"] = message.dictValue
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            completion(chat)
        }
    }
    
    
    
    static func sendImageMessage(_ message: PhotoMessage, for chat: Chat, success: ((Bool)->Void)? = nil){
        guard let chatKey = chat.key else{
            success?(false)
            return
        }
        var multipleUpdateValue = [String: Any]()
        
        for uid in chat.memberUIDs{
            let lastMesage = "\(message.sender): \(String(describing: message.photoContent))"
            multipleUpdateValue["chats/\(uid)/\(chatKey)/lastMessage"] = lastMesage
            multipleUpdateValue["chats/\(uid)\(chatKey)/lastMessageSent"] = message.timestamp.timeIntervalSince1970
        }
        
        
        
        let messagesRef = Database.database().reference().child("images").child(chatKey).childByAutoId()
        let messageKey = messagesRef.key
        multipleUpdateValue["messages/\(chatKey)/\(messageKey)"] = message.dictValue
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multipleUpdateValue, withCompletionBlock: { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success?(false)
                return
            }
            
            success?(true)
            
        })
    }
    
    static func sendMessage(_ message: Message, for chat: Chat, success: ((Bool)->Void)? = nil){
        guard let chatKey = chat.key else{
            success?(false)
            return
        }
        var multipleUpdateValue = [String: Any]()
        
        for uid in chat.memberUIDs{
            let lastMesage = "\(message.sender.username): \(message.content)"
            multipleUpdateValue["chats/\(uid)/\(chatKey)/lastMessage"] = lastMesage
            print(message.timestamp.timeIntervalSince1970)
            print(chatKey)
            multipleUpdateValue["chats/\(uid)/\(chatKey)/lastMessageSent"] = message.timestamp.timeIntervalSince1970
        }
        let messagesRef = Database.database().reference().child("messages").child(chatKey).childByAutoId()
        let messageKey = messagesRef.key
        multipleUpdateValue["messages/\(chatKey)/\(messageKey)"] = message.dictValue
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multipleUpdateValue, withCompletionBlock: { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success?(false)
                return
            }
            
            success?(true)
            
        })
    }
    
    static func observeMessages(forChatKey chatKey: String, completion: @escaping (DatabaseReference, Message?) -> Void) -> DatabaseHandle {
        let messagesRef = Database.database().reference().child("messages").child(chatKey)
        
        return messagesRef.observe(.childAdded, with: { snapshot in
            guard let message = Message(snapshot: snapshot) else {
                return completion(messagesRef, nil)
            }
            
            completion(messagesRef, message)
        })
    }
    
    static func checkForExistingChat(with user: User, completion: @escaping (Chat?)-> Void){
        let members = [user, User.current]
        let hashValue = Chat.hash(forMembers: members)
        
        let chatRef = Database.database().reference().child("chats").child(User.current.uid)
        let query = chatRef.queryOrdered(byChild: "memberHash").queryEqual(toValue: hashValue)
        
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let chatSnap = snapshot.children.allObjects.first as? DataSnapshot,
                let chat = Chat(snapshot: chatSnap)
                else{return completion(nil)}
            completion (chat)
        })
    }
    
    static func deleteChat(){
        
    }
}
