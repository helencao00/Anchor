//
//  ProfileViewController.swift
//  Anchor
//
//  Created by Helen Cao on 8/3/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!

    var authHandle: AuthStateDidChangeListenerHandle?
    var profileRef: DatabaseReference?
    var profileHandle: DatabaseHandle = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = User.current.username
        logoutButton.layer.cornerRadius = 6
        logoutButton.layer.borderColor = UIColor.lightGray.cgColor
        logoutButton.layer.borderWidth = 1
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            print(self.view.window?.rootViewController?.childViewControllers)
            print(self.view.window?.rootViewController?.childViewControllers.count)
            
            self.performSegue(withIdentifier: "toMain", sender: self)

        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        
        profileRef?.removeObserver(withHandle: profileHandle)
    }

    func didTapLogoutButton(_ button: UIButton, on viewController: ProfileViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        didTapLogoutButton(logoutButton, on: self)
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
//extension ProfileViewController: UICollectionViewDelegate{
//    
//
//}
//
//extension ProfileViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath)
//        return cell
//    }
//}





