//
//  GenerateQRCodeViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/24/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import CoreImage
class GenerateQRCodeViewController: UIViewController {

    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var userInputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        if userInputTextField.text != ""{
        let image = Barcode.fromString(string: "\(String(describing: userInputTextField.text))")
        //let convert = Barcode.convertToUIImage(cmage: image!)
            let input = image
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let output: CIImage? = input?.applying(transform)
            let imageOutput = Barcode.convertToUIImage(cmage: output!)
        self.QRCodeImageView.image = imageOutput
        }
        else{
            userInputTextField.text = "Please insert text"
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
