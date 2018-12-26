//
//  ColorTool.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    public class func colorWithHex(_ hex : String? , alpha : CGFloat) -> UIColor?{
        var cString:String = hex!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    
}

extension UIView{
    public func colorChange(color1: UIColor, color2: UIColor){
        let colorArr = [color2.cgColor, color1.cgColor]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArr
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.clipsToBounds = true
    }
}
