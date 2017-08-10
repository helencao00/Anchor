//
//  OptionsViewController.swift
//  Anchor
//
//  Created by Helen Cao on 8/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var generateButton: UIButton!
    
    @IBOutlet weak var translateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeShape(button: generateButton)
        changeShape(button: translateButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeShape(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        
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
