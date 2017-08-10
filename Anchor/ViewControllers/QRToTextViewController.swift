//
//  QRToTextViewController.swift
//  Anchor
//
//  Created by Helen Cao on 7/24/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class QRToTextViewController:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    // MARK: - Properties
    
    @IBOutlet weak var scanButton: UIButton!
    let picker = UIImagePickerController()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTranslate" {
            let destination = segue.destination as? TranslateToTextViewController
            destination?.image = selectedImage!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        translateButton.isHidden = true
        changeShape(button: choosePhotoButton)
        changeShape(button: scanButton)
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

    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        self.selectedImage = chosenImage
        imageView.backgroundColor = UIColor(white: 0, alpha: 0)
        dismiss(animated:true, completion: nil) //5
        if selectedImage != nil{
            translateButton.isHidden = false
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
        if selectedImage != nil{
            translateButton.isHidden = false
        }
    }

}

