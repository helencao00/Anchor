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
import SafariServices
class ScannerCamera: UIViewController, SFSafariViewControllerDelegate {
   
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    
    static var urll: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: previewView)
//        let overlayPath = UIBezierPath(rect: self.view.bounds)
//        self.view.layoutIfNeeded()
//        let x = 32
//        let y = 32
//        let rect = CGRect(
//            origin: CGPoint(x: x, y: y),
//            size: CGSize(dictionaryRepresentation: self.view.frame.size.width * 80 * 0.01)
////            UIScreen.main.bounds.size
//        )
////        let overlayWidth = self.view.frame.size.width * 80 * 0.01
//        let transparentPath = UIBezierPath.init(rect: rect)
//        overlayPath.append(transparentPath)
//        overlayPath.usesEvenOddFillRule = true
//        let fillLayer = CAShapeLayer.init(layer: transparentPath)
//        fillLayer.path = overlayPath.cgPath
//        fillLayer.fillRule = kCAFillRuleEvenOdd
//        fillLayer.fillColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.8).cgColor
//        self.previewView.layer.addSublayer(fillLayer)
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                                    let safariVC = SFSafariViewController(url: ScannerCamera.urll!)
                                    
                                    safariVC.delegate = self as SFSafariViewControllerDelegate
                                    self.present(safariVC, animated: true, completion: nil)
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
                let alertController = UIAlertController(title: "Error", message: "Permission is needed to perform function", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    
}
