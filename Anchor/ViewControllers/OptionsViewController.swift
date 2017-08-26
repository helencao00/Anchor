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
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        generateButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.generateButton.transform = .identity
            },completion: { _ in
                self.performSegue(withIdentifier: "toGenerator", sender: self)
        })
    }


    @IBAction func translateButtonTapped(_ sender: UIButton) {
        translateButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.translateButton.transform = .identity
            },completion: { _ in
                self.performSegue(withIdentifier: "toText", sender: self)
        })

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
