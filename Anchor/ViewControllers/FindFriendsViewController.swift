//
//  FindusersViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class FindFriendsViewController: UIViewController {
    
    
    var fiilteredUsers = [User]()
    var users = [User]()
    var nonfriends = [User]()
    
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
    //        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //            if searchController.isActive && searchController.searchBar.text != ""{
    //
    //                friend = fiilteredUsers[indexPath.row]
    //            } else {
    //
    //                friend = users[indexPath.row]
    //            }
    //
    //        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            let count = users.count
            print("Users count: \(count)")
            
            var friendsCount = 0
            for usern in users{
                FollowService.isUserFollowed(usern) { isFriend in
                    if isFriend == false{
                        self.nonfriends.append(usern)
                    } else {
                        friendsCount += 1
                        usern.isFriends = true
                    }
                    if users.count - friendsCount == self.nonfriends.count {
                        self.users = self.nonfriends
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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

extension FindFriendsViewController: UITableViewDelegate{
    //    func didTapFollowButton(_ followButton: UIButton, on cell: FindusersCell) {
    //        guard let indexPath = tableView.indexPath(for: cell) else { return }
    //        print("bjjij")
    //        followButton.isUserInteractionEnabled = false
    ////        let followee = users[indexPath.row]
    //
    //        FollowService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
    //            defer {
    //                followButton.isUserInteractionEnabled = true
    //            }
    //
    //            guard success else { return }
    //
    //            followee.isFollowed = !followee.isFollowed
    //            //            cell.backgroundColor
    //            self.tableView.reloadRows(at: [indexPath], with: .none)
    //        }
    //    }
    
}

extension FindFriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return fiilteredUsers.count
        }
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FindFriendsCell
        cell.selectionStyle = .none
        var friend: User
        //cell.delegate = self
        
        cell.tapAction = { (celll) in
            print(cell.addFriendButton.isSelected)
            FollowService.setIsFollowing(!cell.addFriendButton.isSelected, fromCurrentUserTo: cell.user! , success: {(success) in
                defer {
                    cell.addFriendButton.isUserInteractionEnabled = true
                }
                
                guard success else { return }
                
                cell.addFriendButton.isSelected = !cell.addFriendButton.isSelected
                
                //            cell.backgroundColor
                let indexNum = tableView.indexPath(for: cell)
                self.nonfriends[(indexNum?.row)!].isFriends = !self.nonfriends[(indexNum?.row)!].isFriends
                self.tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            )}
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            friend = fiilteredUsers[indexPath.row]
            
        } else {
            
            friend = users[indexPath.row]
        }
        
        cell.user = friend
        
        /*
         then when you get your users from firebase set the user.isfriend to true when setting them as a friend
         then in your cellForRowat you simply check if that person isa friend
         and if they are then set cell.addfriendbutton.isSelcted = true
         else false
         
         */
        cell.addFriendButton.isSelected = (friend.isFriends) ? true: false
        cell.usernameLabel?.text = friend.username
        
        return cell
    }
    
}

extension FindFriendsViewController: FindFriendsCellDelegate {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("bjjij")
        followButton.isUserInteractionEnabled = false
        let followee = users[indexPath.row]
        
        FollowService.setIsFollowing(!followee.isFriends, fromCurrentUserTo: followee) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }
            
            guard success == true else { return }
            
            followee.isFriends = !followee.isFriends
            //            cell.backgroundColor
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
    }
    
}

extension FindFriendsViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filterContentForSearchText(searchText: text)
        }
    }
}
