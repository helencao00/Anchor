//
//  ChatViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import JSQMessagesViewController
import JSQSystemSoundPlayer
import CoreImage

class ChatViewController: JSQMessagesViewController {
    
    // MARK: - Properties
    
    var chat: Chat!
    var messages = [Message]()
    var qrmode = false
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        let color = UIColor.jsq_messageBubbleBlue()
        return bubbleImageFactory.outgoingMessagesBubbleImage(with: color)
    }()
    
    var incomingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        let color = UIColor.jsq_messageBubbleLightGray()
        return bubbleImageFactory.incomingMessagesBubbleImage(with: color)
    }()
    var messagesHandle: DatabaseHandle = 0
    var messagesRef: DatabaseReference?
    
    @IBAction func toMainChat(_ sender: UIBarButtonItem) {
//        print(self.navigationController?.viewControllers)
//        let chatListViewController = self.navigationController?.viewControllers[1] as! ChatListViewController
//        let chatList = ChatListViewController as UIViewController
//        self.navigationController?.popToViewController(chatListViewController, animated: true)
        self.performSegue(withIdentifier: "toChatList", sender: self)
    }
   // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupJSQMessagesViewController()
        tryObservingMessages()
    }
    
    deinit {
        messagesRef?.removeObserver(withHandle: messagesHandle)
    }
    
    
    func setupJSQMessagesViewController() {
        senderId = User.current.uid
        senderDisplayName = User.current.username
        title = chat.title
     
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    func tryObservingMessages() {
        guard let chatKey = chat?.key else { return }
        
        messagesHandle = ChatService.observeMessages(forChatKey: chatKey, completion: { [weak self] (ref, message) in
            self?.messagesRef = ref
            
            if let message = message {
                self?.messages.append(message)
                self?.finishReceivingMessage()
            }
        })
    }
}
// MARK: - JSQMessagesCollectionViewDataSource

extension ChatViewController {
    // 1
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 2
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // 3
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item].jsqMessageValue
    }
    
    // 4
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let sender = message.sender
        
        if sender.uid == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    // 5
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = (message.sender.uid == senderId) ? .white : .black
        return cell
    }
}

// MARK: - Send Message

extension ChatViewController {
    func sendMessage(_ message: Message) {
        // 1
        if chat?.key == nil {
            // 2
            ChatService.create(from: message, with: chat, completion: { [weak self] chat in
                guard let chat = chat else { return }
                
                self?.chat = chat
                
                // 3
                self?.tryObservingMessages()
            })
        } else {
            // 4
            ChatService.sendMessage(message, for: chat)
        }
    }
    
    func sendImageMessage(_ message: PhotoMessage){
        
        if chat?.key == nil {
            ChatService.create(from: message, with: chat, completion: { [weak self] chat in
                guard let chat = chat else{return}
                self?.chat = chat
                self?.tryObservingMessages()
            })
        }else{
            ChatService.sendImageMessage(message, for: chat)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        qrmode = !qrmode
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if qrmode == false{
       
        let message = Message(content: text)
     
        sendMessage(message)
            
        finishSendingMessage()
 
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        }else{
            let image = Barcode.fromString(string: text)
            let convert = Barcode.convertToUIImage(cmage: image!)
            let chatMembers = NewMessageViewController.getChatMembers
            let storageRef = Storage.storage().reference().child("chat").child("userid").child("\(chatMembers)")
            
            
            //        storageRef.downloadURL { (url, error) in
            //            if error != nil {
            //                print(error?.localizedDescription)
            //            } else {
            //                self.downloadURl = url
            //                let data = try! Data(contentsOf: url!)
            //                let image = UIImage(data: data)
            //                self.photoContent = JSQPhotoMediaItem(image: image!)
            //            }
            //        }
            //        let image = content.
            
            let data = UIImageJPEGRepresentation(convert, 0.5)
            
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!.localizedDescription)
                }else{
                    
                    let realImage = PhotoMessage.init(content: convert, downloadURL: (metadata?.downloadURLs?.first!)!)
                    //        let input = image
                    //        let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
                    //        let output: CIImage? = input?.applying(transform)
                    //        let imageOutput = Barcode.convertToUIImage(cmage: output!)
                    //        let mediaItem = JSQPhotoMediaItem(image: imageOutput)
                    //        mediaItem?.appliesMediaViewMaskAsOutgoing = true
                    //        let sendMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: mediaItem)
                    //        self.jsqMessages.append(sendMessage!)
                    //        let message = mediaItem
                    self.sendImageMessage(realImage)
                }
            }

            
            
        }
    }
}

// MARK: - UITableViewDelegate



// MARK: - Navigation

