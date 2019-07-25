//
//  extensions.swift
//  Marvel
//
//  Created by Marcos Amorim on 22/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
}

extension UIImage {
    
    func resizeImage(newSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = newSize.width  / size.width
        let heightRatio = newSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

extension UILabel{
    
    func diagonalEdges() {
        let path = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor.white.cgColor
        path.move(to: CGPoint(x: self.bounds.origin.x + 10, y: self.bounds.origin.y))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX - 10, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.close()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
    
}

extension UIButton{
    
    func diagonalCorners() {
        let path = UIBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor.white.cgColor
        path.move(to: CGPoint(x: self.bounds.origin.x + 12, y: self.bounds.origin.y))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY - 12))
        path.addLine(to: CGPoint(x: self.bounds.maxX - 12, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY + 12))
        path.close()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
    
}

extension UINavigationController {
    
    func becomeTransparent(){
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationBar.backgroundColor = .clear
        
    }
    
    func becomeBlack(){
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.isOpaque = true
        self.view.backgroundColor = .black
        self.navigationBar.backgroundColor = .black
        
    }
    
}
