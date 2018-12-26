//
//  BallView.swift
//  KY28Game
//
//  Created by JACK on 2018/10/23.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

enum BALLTYPE: String {
    case WHITEB = "白球"
    case BALL1 = "一号球"
    case BALL2 = "二号球"
    case BALL3 = "三号球"
    case BALL4 = "四号球"
    case BALL5 = "五号球"
    case BALL6 = "六号球"
    case BALL7 = "七号球"
    case BALL8 = "八号球"
    case BALL9 = "九号球"
    case BALL10 = "十号球"
    case BALL11 = "十一号球"
    case BALL12 = "十二号球"
    case BALL13 = "十三号球"
    case BALL14 = "十四号球"
    case BALL15 = "十五号球"
}

class BallView: UIView {

    private var imageView : UIImageView?
    var name : BALLTYPE?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        if self.imageView == nil{
            self.imageView = UIImageView.init(frame: self.bounds)
            self.addSubview(self.imageView!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image : UIImage){
        self.imageView?.image = image
    }
    
    override var frame: CGRect{
//        set{
//            frame = newValue
//            self.layer.cornerRadius = self.frame.size.height/2
//            self.clipsToBounds = true
//            if self.imageView == nil{
//                self.imageView = UIImageView.init(frame: self.bounds)
//            }
//
//        }
//        get{
//            return frame
//        }
        
        didSet{
            self.layer.cornerRadius = self.frame.size.height/2
            self.clipsToBounds = true
            if self.imageView == nil{
                self.imageView = UIImageView.init(frame: self.bounds)
                self.addSubview(self.imageView!)
            }
        }
        
        
    }
    
    
}
