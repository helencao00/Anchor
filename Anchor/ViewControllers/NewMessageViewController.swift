//
//  NewMessageViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    // MARK: - Properties
    
    var followers = [User]()
    var members = [User]()
    var selectedUser: User?
    var existingChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView = UITableView()
        //        tableView.dataSource = self
        //        tableView.delegate = self
        nextButton.isEnabled = false
        // remove separators for empty cells
        //tableView.tableFooterView = UIView()
        self.tableView.allowsMultipleSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        //        DispatchQueue.global(qos: .userInitiated).async {
        //
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            
            _ = users.count
            //                print("Users count: \(count)")
            
            var notfriendsCount = 0
            if !self.followers.isEmpty{
                print("Already here")
            }else{
                
                
            for usern in users{
                FollowService.isUserFollowed(usern) { isFriend in
                    if isFriend{
                        self.followers.append(usern)
                        //                            print(self.followers)
                    } else {
                        notfriendsCount += 1
                        
                    }
                    print("friends count from viewDidLoad \(notfriendsCount)", self.followers.count )
                    
                    if users.count - notfriendsCount == self.followers.count {
                        DispatchQueue.main.async {
                            print(self.followers)
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
            }
            
            //            self.getFriendsList(completion: { following in
            //                self.following = following
            
        }
        
        //        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        // 1
        guard let selectedUser = selectedUser else { return }
        //
        //        // 2
                sender.isEnabled = false
        //        // 3
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            // 4
            sender.isEnabled = true
            self.existingChat = chat
            
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getFriendsList(completion: @escaping ([User])-> ()){
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            //            self.userss = users
            for usern in users {
                FollowService.isUserFollowed(usern) { isFriend in
                    if isFriend {
                        self.followers.append(usern)
                    }
                    //                        else{
                    //                            self.following = FollowService.friendsList
                    //                        }
                }
            }
            completion(self.followers)
        }
    }
    
    func getChatMembers() -> String{
        return "\(User.current) \(String(describing: self.selectedUser))"
    }
}
extension NewMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows followers count: \(followers.count)")
        return (followers.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newChat") as! NewChatUserCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: NewChatUserCell, at indexPath: IndexPath) {
        let follower = followers[indexPath.row]
        cell.newUsernameLabel?.text = follower.username
        
        if let selectedUser = selectedUser, selectedUser.uid == follower.uid {
            print(selectedUser)
            cell.accessoryType = .checkmark
            nextButton.isEnabled = true
        } else {
            cell.accessoryType = .none
        }
    }
}
extension NewMessageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewChatUserCell
        selectedUser = followers[indexPath.row]
        cell.accessoryType = .checkmark
        tableView.reloadData()
        nextButton.isEnabled = true
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
extension NewMessageViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toChat", let destination = segue.destination as? ChatViewController, let selectedUser = selectedUser {
            
            members = [selectedUser, User.current]
            destination.chat = existingChat ?? Chat(members: members)
        }
    }
    
}
