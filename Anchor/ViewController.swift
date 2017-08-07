//
//  ViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/20/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var chatButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Anchor"
        
    }
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func chatButtonTapped(_ sender: UIButton) {
        configureInitialRootViewController(for: self.view.window)
    }
    
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            
            self.performSegue(withIdentifier: "toChat", sender: self)
        } else {
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }
        
    }

}

