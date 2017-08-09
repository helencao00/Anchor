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
    let preferredlanguage = NSLocale.preferredLanguages[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func checkIllegalCharacters(input: String) -> Bool{
//        let realString = input.trimmingCharacters(in: CharacterSet.whitespaces)
//        for char in realString.characters {
//            if char.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
//                return false
//            }
//        }
//        return true
//       
//        
//    }
    
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        if let text = userInputTextField.text{
            let realString = text.trimmingCharacters(in: CharacterSet.whitespaces)
            if realString.containsEmoji || realString.asciiArray.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Text cannot contain special characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let image = Barcode.fromString(string: userInputTextField.text!)
                //let convert = Barcode.convertToUIImage(cmage: image!)
                let input = image
                let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
                let output: CIImage? = input?.applying(transform)
                let imageOutput = Barcode.convertToUIImage(cmage: output!)
                self.QRCodeImageView.image = imageOutput
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func save(_ sender: Any) {
        if QRCodeImageView.image != nil{
        UIImageWriteToSavedPhotosAlbum(QRCodeImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            let ac = UIAlertController(title: "Save error", message: "No QR Code detected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your QR Code has been saved to your photos.", preferredStyle: .alert)
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

extension String {
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF:  // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}

