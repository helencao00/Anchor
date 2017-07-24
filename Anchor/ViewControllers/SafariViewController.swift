//
//  SafariViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/21/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: UIViewController, SFSafariViewControllerDelegate {
    var hasBeenLoaded:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if hasBeenLoaded == false{
        let safariVC = SFSafariViewController(url: ScannerCamera.urll!)
        
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        self.dismiss(animated: true, completion: nil)
        self.hasBeenLoaded = true
    
        self.navigationController?.popViewController(animated: true)
        

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
