//
//  ScanTextViewController.swift
//  Anchor
//
//  Created by Helen Cao on 8/25/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ScanTextViewController: UIViewController {
    var stringer: String?
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stringer = ScannerCamera.stringg
        textLabel.text = stringer
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
