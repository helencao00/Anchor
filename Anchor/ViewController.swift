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

    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "AnchorQR"
        changeShape(button: chatButton)
        changeShape(button: scanButton)
        changeShape(button: convertButton)
        
    }
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func chatButtonTapped(_ sender: UIButton) {
        chatButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: { [weak self] in
                self?.chatButton.transform = .identity
            }, completion: { _ in
                self.configureInitialRootViewController(for: self.view.window)
        })
//        configureInitialRootViewController(for: self.view.window)
    }
    
    func changeShape(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        
    }
    
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
//        let initialViewController: UIViewController
        
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


