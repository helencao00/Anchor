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
        userInputTextField.delegate = self
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(QRCodeImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
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

extension GenerateQRCodeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

