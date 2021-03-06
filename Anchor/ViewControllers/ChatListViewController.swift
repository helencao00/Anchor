//
//  ChatViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/25/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatListViewController: UIViewController {
    @IBOutlet weak var introLabel: UILabel!
     var chats = [Chat]()
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?
    var formatedDate: ()
  
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.backgroundView = nil
//        tableView.backgroundView = view
        self.tableView.isHidden = false
        self.introLabel.text = ""

        self.tableView.backgroundColor = UIColor(red: 255, green: 229, blue: 182, alpha: 1)
//        tableView.transform = CGAffineTransform(scaleX: -1,y: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userChatsHandle = UserService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats
            self?.chats.sort(by: {$0.lastMessageSent!.compare($1.lastMessageSent! as Date) == ComparisonResult.orderedDescending})
//            print(chats)
            if chats.count == 0{
                self?.tableView.isHidden = true
                self?.introLabel.text = "Tap find friends in the lower left corner to chat"
            } else {
                self?.tableView.isHidden = false
                self?.introLabel.text = ""
            }
          
        
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.animateTable()
            }
           
        }
//        animateTable()
//        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // 4
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func unwindToChatList(_ segue: UIStoryboardSegue){
        
    }
    
//    @IBAction func toMainView(_ sender: UIBarButtonItem) {
//        
////        self.navigationController!.popToRootViewController(animated: true)
//        self.performSegue(withIdentifier: "unwindToMain", sender: self)
//    }
   
//    @IBAction func unwindToChatList(_ segue: UIStoryboardSegue) {
////    print("Abid gets 60% of my app")
//    }

    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
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

}

extension ChatListViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return chats.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "username") as! ChatListViewCell
        cell.selectionStyle = .none
        
        let chat = chats[indexPath.row]
        cell.usernameLabel.text = chat.title

        cell.lastMessageLabel.text = chat.lastMessage
        
        let formatter = DateFormatter()
//        // initially set the format based on your datepicker date
        formatter.dateFormat = "E, MMM d yyyy hh:mm"
        
        
        
        // let myString = formatter.string(from: Date())
        // convert your string to date
//        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
//        formatter.dateFormat = "dd-MM-yy"
        // again convert your date to string
        
//        chat.lastMessageSent = formatter.dateFormat = "dd-MM-yy"
//        let myStringafd = formatter.string(from: chat.lastMessageSent!)
//        
//        let inFormatter = DateFormatter()
//        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//        inFormatter.dateFormat = "HH:mm"
//        
//        let outFormatter = DateFormatter()
//        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//        outFormatter.dateFormat = "hh:mm"
//        
//        
//        let inDate = chat.lastMessageSent
//        let outString = outFormatter.string(from: inDate!)
//        print(outString)
//        print(myStringafd)
        let dateString = formatter.string(from: chat.lastMessageSent!)
//        print(dateString)
        cell.dateLabel.text = dateString
//        cell.timeLabel.text = outString
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         cell.contentView.backgroundColor = UIColor(red: 255, green: 229, blue: 182, alpha: 1)
    }

}

extension ChatListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
        
    }
}

extension ChatListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toChat",
            let destination = segue.destination as? ChatViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            destination.chat = chats[indexPath.row]
            if segue.identifier == "toNewChat"{
                performSegue(withIdentifier: "toNewChat", sender: self)
            }
        }
    }
}
