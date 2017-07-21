//
//  ScannerCamera.swift
//  Anchor
//
//  Created by Helen Cao on 7/20/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import AVFoundation
import MTBBarcodeScanner

class ScannerCamera: UIViewController {
   
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    
    static var urll: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: previewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                let stringValue = code.stringValue!
                                print("Found code: \(stringValue)")
                                ScannerCamera.urll = URL(string: stringValue)
                                if ScannerCamera.urll != nil{
                                if UIApplication.shared.canOpenURL(ScannerCamera.urll!){
                                   self.performSegue(withIdentifier: "toWeb", sender: self)
                                }
                                }else{
                                    print("frick")
                                }

                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                let alertController = UIAlertController(title: "Hey AppCoda", message: "What do you want to do?", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    
}
