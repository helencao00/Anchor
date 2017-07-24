//
//  Barcode.swift
//  Anchor
//
//  Created by Helen Cao on 7/24/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import AVFoundation
class Barcode {
    
    class func fromString(string : String) -> CIImage? {
        
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        //  let qrcodeImage = filter?.outputImage
        return filter?.outputImage
    }
    
    class func toString(barcodeImage: CIImage) -> String {
        
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context:nil, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        // let ciimg = CIImage(cgImage: cgImage)
        let features = detector.features(in: barcodeImage)
        let please = features.first as! CIQRCodeFeature
        return "\(please.messageString!)"
        //for feature in features as! [CIQRCodeFeature] {
        //   print(feature.messageString!)
        
        //}
        
    }
    
    class func convertToUIImage(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
   
}
