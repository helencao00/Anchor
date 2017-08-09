//
//  FriendsViewController.swift
//  Anchor
//
//  Created by Helen Cao on 8/1/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class FriendsViewController: UIViewController {
    
    
    var fiilteredUsers = [User]()
    var users = [User]()
    var friends = [User]()
    var selectedUser: User?
    var existingChat: Chat?
    @IBOutlet weak var tableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        // Do any additional setup after loading the view.
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if searchController.isActive && searchController.searchBar.text != ""{
    //
    //            friend = fiilteredUsers[indexPath.row]
    //        } else {
    //
    //            friend = users[indexPath.row]
    //        }
    //
    //    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
           
            self.friends.removeAll()
            if self.friends.isEmpty{
                var friendsCount = 0
                for usern in users{
                    FollowService.isUserFollowed(usern) { isFriend in
                        if isFriend == true{
                            self.friends.append(usern)
                        } else {
                            friendsCount += 1
                        }
                        if users.count - friendsCount == self.friends.count {
                            self.users = self.friends
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
            //            self.users.removeAll()
            //            for usu in self.nonfriends{
            //                self.users.append(usu)
            //            }
            //        FollowService.isUserFollowed(friend) {isFriend in
            //
            //            if isFriend == true{
            //                print("y'all are friends")
            //            } else{
            //                cell.user = friend
            //                cell.usernameLabel?.text = friend.username
            //            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func chatWithUser(_ sender: UIButton) {
        guard let selectedUser = selectedUser else { return }
        
        //
        //        // 2
        //        sender.isEnabled = false
        //        // 3
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
         
            self.existingChat = chat
            
                  }

    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        fiilteredUsers = users.filter { userr in
            let trimmedString = searchText.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            if trimmedString.characters.count > 0 {
                
                
                if userr.username.lowercased().hasPrefix(trimmedString) == true{
                    print(userr)
                    return userr.username.lowercased().hasPrefix(trimmedString)
                }
            }
            
            return false
        }
        tableView.reloadData()
    }
    
//    @IBAction func chatButtonTapped(_ sender: UIButton) {
//        print("chat touched")
//        guard let selectedUser = selectedUser else { return }
//       
//        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
//          
//            self.existingChat = chat
//            
//            self.performSegue(withIdentifier: "toChat", sender: self)
//        }
//    }
    
    
    //    func filterContentForSearchText(searchText: String, scope: String = "All") {
    //        users = users.filter { User in
    //            return User.username.lowercased().contains(searchText.lowercased())
    //          // return User.username.lowercaseString.containsString(searchText.lowercaseString)
    //        }
    //
    //        tableView.reloadData()
    //    }
    //
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FriendsViewController: UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}

extension FriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return fiilteredUsers.count
        }
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actualFriend", for: indexPath) as! FriendCell
        
//        selectedUser = friends[indexPath.row]

        var friend: User
        if searchController.isActive && searchController.searchBar.text != ""{
            
            friend = fiilteredUsers[indexPath.row]
        } else {
            
            friend = users[indexPath.row]
        }
        
        cell.usernameLabel?.text = friend.username
        //cell.selectionStyle = .none
   

        cell.completionHandler = { [weak self] (cell) in
            guard let selectedUser = self?.selectedUser else { return }
            
            ChatService.checkForExistingChat(with: selectedUser) { (chat) in
                
                self?.existingChat = chat
                
                self?.performSegue(withIdentifier: "toChat", sender: self)
            }
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = friends[indexPath.row]
       
        
//        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
//            
//            self.existingChat = chat
//            
//        }
        
        guard let selectedUser = self.selectedUser else { return }
        
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            
            self.existingChat = chat
            
            self.performSegue(withIdentifier: "toChat", sender: self)
            
        }
        
        
    }
}


extension FriendsViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filterContentForSearchText(searchText: text)
        }
    }
}

extension FriendsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toChat", let destination = segue.destination as? ChatViewController, let selectedUser = selectedUser {
            
            let members = [selectedUser, User.current]
            destination.chat = existingChat ?? Chat(members: members)
            
        }
    }
}
